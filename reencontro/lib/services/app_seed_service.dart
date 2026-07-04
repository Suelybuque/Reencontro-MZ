import 'package:cloud_firestore/cloud_firestore.dart';

class AppSeedService {
  AppSeedService._();

  static final instance = AppSeedService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedIfNeeded() async {
    final metaRef = _firestore.collection('app_meta').doc('seed');
    final metaSnapshot = await metaRef.get();
    if (metaSnapshot.exists) {
      return;
    }

    final batch = _firestore.batch();

    for (final record in _missingPeople) {
      final ref = _firestore
          .collection('missing_people')
          .doc(record['id']! as String);
      batch.set(ref, record);
    }

    for (final record in _updates) {
      final ref = _firestore.collection('updates').doc(record['id']! as String);
      batch.set(ref, record);
    }

    for (final record in _centers) {
      final ref = _firestore
          .collection('support_centers')
          .doc(record['id']! as String);
      batch.set(ref, record);
    }

    batch.set(metaRef, {
      'seededAt': FieldValue.serverTimestamp(),
      'version': 1,
    });

    await batch.commit();
  }
}

final List<Map<String, Object>> _missingPeople = [
  {
    'id': 'sara-manuel',
    'name': 'Sara Manuel',
    'age': '8 anos',
    'status': 'Desaparecida',
    'location': 'Vista Alegre, Beira',
    'lastSeen': 'Há 2 horas',
    'description':
        'Vista pela última vez junto à Escola 25 de Junho durante a evacuação.',
    'imageUrl':
        'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?auto=format&fit=crop&w=1200&q=80',
  },
  {
    'id': 'joel-manuel',
    'name': 'Joel Manuel',
    'age': '5 anos',
    'status': 'Desaparecido',
    'location': 'Munhava',
    'lastSeen': 'Há 1 hora',
    'description': 'Usava camisola azul e seguia com a irmã mais velha.',
    'imageUrl':
        'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?auto=format&fit=crop&w=1200&q=80',
  },
  {
    'id': 'celina-alberto',
    'name': 'Celina Alberto',
    'age': '67 anos',
    'status': 'Procurada',
    'location': 'Dondo',
    'lastSeen': 'Há 3 horas',
    'description':
        'Família procura confirmação em abrigos próximos e centros de saúde.',
    'imageUrl':
        'https://images.unsplash.com/photo-1541534401786-2077eed87a72?auto=format&fit=crop&w=1200&q=80',
  },
  {
    'id': 'antonio-machava',
    'name': 'António M.',
    'age': '11 anos',
    'status': 'Desaparecido',
    'location': 'Bairro Central, Beira',
    'lastSeen': 'Há 2 horas',
    'description':
        'Separado da mãe durante subida das águas no bairro central.',
    'imageUrl':
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAqtpBmkw1XdjywEDCAjydsIrozya5f4xkR7ssE1rdQbgKtkxJnq_OW2lyV3OZ1RFehp2NGKtrmRaGZw39D2DFhrMo_vMotFzKTvDPJmhAJ8stLPLXg1aKzIyOgzspMJl3Q3UZdqE9DUxpdAMv0aKi8OSZurfjChBBBCWSIP9AWDa2t-SJzykCLoUu7ewUY6awY0Ys12pat-ejYtP6G16KHrrRRLbONfsx0WdfuOSsjQH3DjNvvCswCA8BVc4BQ8k9xIt2OxX88Qh3D',
  },
];

final List<Map<String, Object>> _updates = [
  {
    'id': 'update-1',
    'name': 'António M.',
    'location': 'Visto pela última vez em: Bairro Central, Beira',
    'status': 'Desaparecido',
    'timeAgo': 'Há 2 horas',
    'imageUrl':
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAqtpBmkw1XdjywEDCAjydsIrozya5f4xkR7ssE1rdQbgKtkxJnq_OW2lyV3OZ1RFehp2NGKtrmRaGZw39D2DFhrMo_vMotFzKTvDPJmhAJ8stLPLXg1aKzIyOgzspMJl3Q3UZdqE9DUxpdAMv0aKi8OSZurfjChBBBCWSIP9AWDa2t-SJzykCLoUu7ewUY6awY0Ys12pat-ejYtP6G16KHrrRRLbONfsx0WdfuOSsjQH3DjNvvCswCA8BVc4BQ8k9xIt2OxX88Qh3D',
    'details': 'Caso em validação com equipas da Beira.',
  },
  {
    'id': 'update-2',
    'name': 'Maria Santos',
    'location': 'No centro: Pavilhão dos Desportos',
    'status': 'Encontrada',
    'timeAgo': 'Há 45 min',
    'imageUrl':
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxJdbaLO98Lkn1pCjWJxav-NY24etZ1MVvfdtdTO-PO-ChUS02ltyAjg460WlAUTkpF9Hd_lZCta-tMPt0gRAorfSkdsgV-3xOs4rYpe_9R-nwI06ah1PlPbk7WjzH7f6jSitCRIHTMC48jK44usPfxvPxgBAczQMCj6-cHcn90EwhKQfkECt30a4lWwYE-TgSR5Him8OUkLqXCiRvbrVlUrZ9lW059gGLc12b98ImpClJtOeSrIUK49zXydBb8hAoB8XKHLzGsQbU',
    'details': 'Aguardando contacto com familiares já identificados.',
  },
];

final List<Map<String, Object>> _centers = [
  {
    'id': 'center-1',
    'name': 'Centro Comunitário Xipamanine',
    'category': 'Centro Gov',
    'address': 'Maputo, Xipamanine',
    'distanceLabel': '0.8 km de distância',
    'status': 'Disponível',
    'capacity': 200,
    'occupancy': 142,
    'latitude': -25.9426,
    'longitude': 32.5563,
    'description': 'Acolhimento, água potável e triagem básica.',
  },
  {
    'id': 'center-2',
    'name': 'Escola Primária EPC Polana Caniço',
    'category': 'Centro Gov',
    'address': 'Maputo, Polana Caniço',
    'distanceLabel': '2.4 km de distância',
    'status': 'Quase Cheio',
    'capacity': 400,
    'occupancy': 385,
    'latitude': -25.9458,
    'longitude': 32.6089,
    'description': 'Espaço com alimentação e zona de descanso para famílias.',
  },
  {
    'id': 'center-3',
    'name': 'Igreja Paroquial de Maputo',
    'category': 'Cruz Vermelha',
    'address': 'Maputo, Baixa',
    'distanceLabel': '3.1 km de distância',
    'status': 'Lotado',
    'capacity': 150,
    'occupancy': 150,
    'latitude': -25.9692,
    'longitude': 32.5732,
    'description': 'Ponto de apoio espiritual e distribuição de mantimentos.',
  },
  {
    'id': 'center-4',
    'name': 'Escola Secundária da Manga',
    'category': 'Centro de Acolhimento',
    'address': 'Beira, Manga',
    'distanceLabel': '1.2 km',
    'status': 'Disponível',
    'capacity': 250,
    'occupancy': 170,
    'latitude': -19.8335,
    'longitude': 34.8422,
    'description': 'Abrigo com enfermaria e zona infantil.',
  },
  {
    'id': 'center-5',
    'name': 'Pavilhão dos Desportos da Beira',
    'category': 'Centro Gov',
    'address': 'Beira',
    'distanceLabel': '2.7 km',
    'status': 'Disponível',
    'capacity': 320,
    'occupancy': 246,
    'latitude': -19.8327,
    'longitude': 34.8446,
    'description': 'Centro de acolhimento com zona de descanso e apoio médico.',
  },
  {
    'id': 'center-6',
    'name': 'Centro Comunitário Munhava',
    'category': 'Cruz Vermelha',
    'address': 'Beira, Munhava',
    'distanceLabel': '4.0 km',
    'status': 'Disponível',
    'capacity': 180,
    'occupancy': 88,
    'latitude': -19.8551,
    'longitude': 34.8387,
    'description': 'Distribuição de água, mantas e medicação pediátrica.',
  },
  {
    'id': 'center-7',
    'name': 'Abrigo Escola 7 de Abril',
    'category': 'Centro de Acolhimento',
    'address': 'Beira',
    'distanceLabel': '5 km',
    'status': 'Disponível',
    'capacity': 180,
    'occupancy': 142,
    'latitude': -19.8389,
    'longitude': 34.8653,
    'description': 'Abrigo com casos de reunificação em andamento.',
  },
  {
    'id': 'center-8',
    'name': 'Pavilhão Estoril',
    'category': 'Centro Gov',
    'address': 'Dondo',
    'distanceLabel': '12 km',
    'status': 'Quase Cheio',
    'capacity': 220,
    'occupancy': 203,
    'latitude': -19.6094,
    'longitude': 34.7431,
    'description': 'Necessita reforço médico e apoio a idosos.',
  },
  {
    'id': 'center-9',
    'name': 'Centro de Trânsito de Nhamatanda',
    'category': 'Centro Gov',
    'address': 'Nhamatanda',
    'distanceLabel': '6.5 km',
    'status': 'Disponível',
    'capacity': 160,
    'occupancy': 96,
    'latitude': -19.1226,
    'longitude': 34.6344,
    'description': 'Atende famílias em trânsito entre Beira e Dondo.',
  },
  {
    'id': 'center-10',
    'name': 'Posto de Apoio de Chimoio',
    'category': 'Cruz Vermelha',
    'address': 'Chimoio',
    'distanceLabel': '3.4 km',
    'status': 'Disponível',
    'capacity': 210,
    'occupancy': 134,
    'latitude': -19.1164,
    'longitude': 33.4833,
    'description': 'Ponto de triagem e alimentação para deslocados.',
  },
  {
    'id': 'center-11',
    'name': 'Centro Escolar de Tete',
    'category': 'Centro Gov',
    'address': 'Tete',
    'distanceLabel': '2.1 km',
    'status': 'Disponível',
    'capacity': 240,
    'occupancy': 120,
    'latitude': -16.1564,
    'longitude': 33.5867,
    'description': 'Alojamento temporário e distribuição de kits de higiene.',
  },
  {
    'id': 'center-12',
    'name': 'Unidade de Apoio de Quelimane',
    'category': 'Centro de Acolhimento',
    'address': 'Quelimane',
    'distanceLabel': '1.9 km',
    'status': 'Disponível',
    'capacity': 300,
    'occupancy': 201,
    'latitude': -17.8781,
    'longitude': 36.8883,
    'description': 'Abrigo costeiro com foco em crianças desacompanhadas.',
  },
  {
    'id': 'center-13',
    'name': 'Casa de Apoio de Nampula',
    'category': 'Cruz Vermelha',
    'address': 'Nampula',
    'distanceLabel': '5.3 km',
    'status': 'Disponível',
    'capacity': 175,
    'occupancy': 110,
    'latitude': -15.1165,
    'longitude': 39.2666,
    'description': 'Assistência alimentar e apoio psicossocial.',
  },
  {
    'id': 'center-14',
    'name': 'Centro Logístico de Pemba',
    'category': 'Centro Gov',
    'address': 'Pemba',
    'distanceLabel': '4.9 km',
    'status': 'Disponível',
    'capacity': 260,
    'occupancy': 130,
    'latitude': -12.9739,
    'longitude': 40.5178,
    'description': 'Coordenação de resposta para a zona norte.',
  },
  {
    'id': 'center-15',
    'name': 'Abrigo de Inhambane',
    'category': 'Centro de Acolhimento',
    'address': 'Inhambane',
    'distanceLabel': '2.8 km',
    'status': 'Disponível',
    'capacity': 140,
    'occupancy': 72,
    'latitude': -23.865,
    'longitude': 35.3833,
    'description': 'Espaço de acolhimento familiar com apoio materno.',
  },
  {
    'id': 'center-16',
    'name': 'Base de Apoio de Xai-Xai',
    'category': 'Centro Gov',
    'address': 'Xai-Xai',
    'distanceLabel': '3.0 km',
    'status': 'Disponível',
    'capacity': 200,
    'occupancy': 98,
    'latitude': -25.0519,
    'longitude': 33.6442,
    'description': 'Centro de recepção e encaminhamento de famílias.',
  },
  {
    'id': 'center-17',
    'name': 'Ponto Solidário de Maxixe',
    'category': 'Cruz Vermelha',
    'address': 'Maxixe',
    'distanceLabel': '1.7 km',
    'status': 'Disponível',
    'capacity': 120,
    'occupancy': 63,
    'latitude': -23.8567,
    'longitude': 35.3472,
    'description': 'Distribuição de alimentos e contacto familiar.',
  },
  {
    'id': 'center-18',
    'name': 'Centro Municipal de Matola',
    'category': 'Centro Gov',
    'address': 'Matola',
    'distanceLabel': '1.1 km',
    'status': 'Disponível',
    'capacity': 280,
    'occupancy': 144,
    'latitude': -25.9622,
    'longitude': 32.4589,
    'description': 'Atende deslocados e faz encaminhamento para abrigos.',
  },
  {
    'id': 'center-19',
    'name': 'Abrigo da Manhiça',
    'category': 'Centro de Acolhimento',
    'address': 'Manhiça',
    'distanceLabel': '8.4 km',
    'status': 'Disponível',
    'capacity': 130,
    'occupancy': 74,
    'latitude': -25.4022,
    'longitude': 32.8072,
    'description': 'Ponto de apoio rural com água e kits de higiene.',
  },
  {
    'id': 'center-20',
    'name': 'Centro de Resposta de Mocuba',
    'category': 'Centro Gov',
    'address': 'Mocuba',
    'distanceLabel': '3.6 km',
    'status': 'Disponível',
    'capacity': 190,
    'occupancy': 112,
    'latitude': -16.8425,
    'longitude': 36.9856,
    'description': 'Coordena busca, abrigo e reunificação familiar.',
  },
];
