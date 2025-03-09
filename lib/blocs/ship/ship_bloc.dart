import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ship_event.dart';
import 'ship_state.dart';

class ShipBloc extends Bloc<ShipEvent, ShipState> {
  static const String _shipsStorageKey = 'ships_data';

  ShipBloc() : super(ShipInitial()) {
    on<LoadShips>((event, emit) async {
      emit(ShipLoading());
      try {
        final ships = await _loadShips();
        emit(ShipsLoaded(ships));
      } catch (e) {
        emit(ShipOperationFailure("Failed to load ships: ${e.toString()}"));
      }
    });

    on<AddShip>((event, emit) async {
      emit(ShipLoading());
      try {
        final ships = await _loadShips();

        // Generate a unique ID (in a real app, this would come from the backend)
        final id = DateTime.now().millisecondsSinceEpoch.toString();

        final newShip = {
          'id': id,
          ...event.shipData,
          'createdAt': DateTime.now().toIso8601String(),
        };

        ships.add(newShip);
        await _saveShips(ships);

        emit(ShipOperationSuccess("Ship added successfully"));
        emit(ShipsLoaded(ships));
      } catch (e) {
        emit(ShipOperationFailure("Failed to add ship: ${e.toString()}"));
      }
    });

    on<UpdateShip>((event, emit) async {
      emit(ShipLoading());
      try {
        final ships = await _loadShips();
        final index = ships.indexWhere((ship) => ship['id'] == event.id);

        if (index != -1) {
          ships[index] = {
            'id': event.id,
            ...event.shipData,
            'updatedAt': DateTime.now().toIso8601String(),
          };

          await _saveShips(ships);

          emit(ShipOperationSuccess("Ship updated successfully"));
          emit(ShipsLoaded(ships));
        } else {
          emit(ShipOperationFailure("Ship not found"));
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to update ship: ${e.toString()}"));
      }
    });

    on<DeleteShip>((event, emit) async {
      emit(ShipLoading());
      try {
        final ships = await _loadShips();
        final filteredShips = ships.where((ship) => ship['id'] != event.id).toList();

        if (ships.length != filteredShips.length) {
          await _saveShips(filteredShips);

          emit(ShipOperationSuccess("Ship deleted successfully"));
          emit(ShipsLoaded(filteredShips));
        } else {
          emit(ShipOperationFailure("Ship not found"));
        }
      } catch (e) {
        emit(ShipOperationFailure("Failed to delete ship: ${e.toString()}"));
      }
    });
  }

  Future<List<Map<String, dynamic>>> _loadShips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shipData = prefs.getString(_shipsStorageKey);

      if (shipData != null) {
        final List<dynamic> decoded = json.decode(shipData);
        return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
      }

      // Return some demo data if no ships are saved
      return [
        {
          'id': '1',
          'name': 'Tàu Cao Tốc A',
          'type': 'Tàu khách',
          'capacity': 150,
          'status': 'Đang hoạt động',
          'route': 'Vũng Tàu - Côn Đảo',
          'imageUrl': 'https://example.com/ship1.jpg',
        },
        {
          'id': '2',
          'name': 'Tàu Du Lịch B',
          'type': 'Tàu du lịch',
          'capacity': 200,
          'status': 'Đang hoạt động',
          'route': 'Nha Trang - Phú Quốc',
          'imageUrl': 'https://example.com/ship2.jpg',
        },
      ];
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  Future<void> _saveShips(List<Map<String, dynamic>> ships) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shipsStorageKey, json.encode(ships));
  }
}