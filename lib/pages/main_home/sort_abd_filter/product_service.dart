class ProductService {
  static List<Map<String, dynamic>> sortNotes(
      List<Map<String, dynamic>> notes, String sortCriteria) {
    switch (sortCriteria) {
      case 'Дешевле':
        notes.sort((a, b) => (a['Price'] ?? 0).compareTo(b['Price'] ?? 0));
        break;
      case 'Дороже':
        notes.sort((a, b) => (b['Price'] ?? 0).compareTo(a['Price'] ?? 0));
        break;
      case 'По алфавиту':
        notes.sort((a, b) => (a['Name'] ?? '').compareTo(b['Name'] ?? ''));
        break;
      case 'Сбросить':
      default:
        return notes;
    }
    return notes;
  }

  static List<Map<String, dynamic>> filterNotes(
      List<Map<String, dynamic>> notes,
      String searchQuery,
      double? minPrice,
      double? maxPrice) {
    var filteredNotes = notes;

    // Фильтрация по цене
    if (minPrice != null) {
      filteredNotes = filteredNotes
          .where((note) => (note['Price'] ?? double.infinity) >= minPrice)
          .toList();
    }

    if (maxPrice != null) {
      filteredNotes = filteredNotes
          .where((note) => (note['Price'] ?? 0) <= maxPrice)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes
          .where((note) => (note['Name'] ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredNotes;
  }
}
