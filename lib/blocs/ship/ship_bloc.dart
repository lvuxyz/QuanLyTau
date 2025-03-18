import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../services/ship_service.dart';
import '../../models/ship.dart';
import 'ship_event.dart';
import 'ship_state.dart';

class ShipBloc extends Bloc<ShipEvent, ShipState> {
  static const String _shipsStorageKey = 'ships_data';
  final ShipService shipService;

  ShipBloc({required this.shipService}) : super(ShipInitial()) {
    on<LoadShips>((event, emit) async {
      emit(ShipLoading());
      try {
        // Try to get ships from API
        final result = await shipService.getShips();

        if (result['success'] == true) {
          final ships = (result['data'] as List<dynamic>).cast<Ship>();
          await _saveShipsToStorage(ships);
          emit(ShipsLoaded(ships));
        } else {
          // If API fails, try to load from local storage as fallback
          final ships = await _loadShipsFromStorage();
          emit(ShipsLoaded(ships));
        }
      } catch (e) {
        try {
          // If everything fails, try to load from local storage
          final ships = await _loadShipsFromStorage();
          emit(ShipsLoaded(ships));
        } catch (e) {
          emit(ShipOperationFailure("Failed to load ships: ${e.toString()}"));
        }
      }
    });

    on<AddShip>((event, emit) async {
      emit(ShipLoading());
      try {
        // Try to add ship via API
        final result = await shipService.addShip(event.ship);

        if (result['success'] == true) {
          emit(ShipOperationSuccess(result['message']));
          add(LoadShips()); // Reload ships from API
        } else {
          // If API fails, add to local storage
          final ships = await _loadShipsFromStorage();

          // Generate a unique ID (in a real app, this would come from the backend)
          final id = DateTime.now().millisecondsSinceEpoch.toString();

          final newShip = event.ship.copyWith(
            id: id,
            createdAt: DateTime.now().toIso8601String(),
          );

          ships.add(newShip);
          await _saveShipsToStorage(ships);

          emit(ShipOperationSuccess("Ship added successfully (offline mode)"));
          emit(ShipsLoaded(ships));
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to add ship: ${e.toString()}"));
      }
    });

    on<UpdateShip>((event, emit) async {
      emit(ShipLoading());
      try {
        // Try to update ship via API
        final result = await shipService.updateShip(event.id, event.ship);

        if (result['success'] == true) {
          emit(ShipOperationSuccess(result['message']));
          add(LoadShips()); // Reload ships from API
        } else {
          // If API fails, update in local storage
          final ships = await _loadShipsFromStorage();
          final index = ships.indexWhere((ship) => ship.id == event.id);

          if (index != -1) {
            final updatedShip = event.ship.copyWith(
              updatedAt: DateTime.now().toIso8601String(),
            );

            ships[index] = updatedShip;
            await _saveShipsToStorage(ships);

            emit(ShipOperationSuccess("Ship updated successfully (offline mode)"));
            emit(ShipsLoaded(ships));
          } else {
            emit(ShipOperationFailure("Ship not found"));
          }
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to update ship: ${e.toString()}"));
      }
    });

    on<DeleteShip>((event, emit) async {
      emit(ShipLoading());
      try {
        // Try to delete ship via API
        final result = await shipService.deleteShip(event.id);

        if (result['success'] == true) {
          emit(ShipOperationSuccess(result['message']));
          add(LoadShips()); // Reload ships from API
        } else {
          // If API fails, delete from local storage
          final ships = await _loadShipsFromStorage();
          final filteredShips = ships.where((ship) => ship.id != event.id).toList();

          if (ships.length != filteredShips.length) {
            await _saveShipsToStorage(filteredShips);

            emit(ShipOperationSuccess("Ship deleted successfully (offline mode)"));
            emit(ShipsLoaded(filteredShips));
          } else {
            emit(ShipOperationFailure("Ship not found"));
          }
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to delete ship: ${e.toString()}"));
      }
    });
    
    on<SearchShips>((event, emit) async {
      emit(ShipLoading());
      try {
        // Try to search ships via API
        final result = await shipService.searchShips(event.query);

        if (result['success'] == true) {
          final ships = (result['data'] as List<dynamic>).cast<Ship>();
          emit(ShipsLoaded(ships));
        } else {
          // If API fails, try to search in local storage
          final allShips = await _loadShipsFromStorage();
          final query = event.query.toLowerCase();
          
          final filteredShips = allShips.where((ship) {
            return ship.name.toLowerCase().contains(query) ||
                  ship.type.toLowerCase().contains(query) ||
                  ship.route.toLowerCase().contains(query);
          }).toList();
          
          emit(ShipsLoaded(filteredShips));
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to search ships: ${e.toString()}"));
      }
    });
  }

  Future<List<Ship>> _loadShipsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shipData = prefs.getString(_shipsStorageKey);

      if (shipData != null) {
        final List<dynamic> decoded = json.decode(shipData);
        return decoded
            .map((item) => Ship.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }

      // Return some demo data if no ships are saved
      return [
        Ship(
          id: '1',
          name: 'Tàu Cao Tốc A',
          type: 'Tàu khách',
          capacity: 150,
          status: 'Đang hoạt động',
          route: 'Vũng Tàu - Côn Đảo',
          imageUrl: 'https://example.com/ship1.jpg',
        ),
        Ship(
          id: '2',
          name: 'Tàu Du Lịch B',
          type: 'Tàu du lịch',
          capacity: 200,
          status: 'Đang hoạt động',
          route: 'Nha Trang - Phú Quốc',
          imageUrl: 'https://example.com/ship2.jpg',
        ),
      ];
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  Future<void> _saveShipsToStorage(List<Ship> ships) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = ships.map((ship) => ship.toJson()).toList();
    await prefs.setString(_shipsStorageKey, json.encode(encodedData));
  }
}