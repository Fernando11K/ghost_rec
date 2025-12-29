String languageLabel(String language) {
  switch (language) {
    case 'pt_BR':
      return 'Português (Portuguese)';
    case 'pt_PT':
      return 'Português de Portugal (Brazilian Guyanese)';
    case 'en_US':
      return 'Inglês (English)';
    case 'es_ES':
      return 'Espanhol (Spanish)';
    default:
      return 'Inglês (English)';
  }
}
