import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mapa_locais/models/local.dart';

class LocalService {
  bool get _firebaseDisponivel {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> get locais {
    if (!_firebaseDisponivel) {
      throw StateError('Firebase não foi inicializado.');
    }
    return FirebaseFirestore.instance.collection('locais');
  }

  Future<void> _exigirFirebase() async {
    if (!_firebaseDisponivel) {
      throw StateError('Firebase não foi inicializado.');
    }
  }

  Stream<List<Local>> listarLocais() {
    if (!_firebaseDisponivel) {
      return Stream.value(const []);
    }

    try {
      return FirebaseFirestore.instance
          .collection('locais')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Local.fromMap(doc.id, doc.data()))
                .toList();
          });
    } catch (_) {
      return Stream.value(const []);
    }
  }

  Future<void> adicionar(Local local) async {
    await _exigirFirebase();
    await locais.add(local.toMap());
  }

  Future<void> atualizar(Local local) async {
    await _exigirFirebase();
    await locais.doc(local.id).update(local.toMap());
  }

  Future<void> excluir(String id) async {
    await _exigirFirebase();
    await locais.doc(id).delete();
  }

  Future<void> alterarFavorito(String id, bool favorito) async {
    await _exigirFirebase();
    await locais.doc(id).update({'favorito': favorito});
  }
}
