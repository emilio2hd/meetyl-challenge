ValidatesTimeliness.setup do |config|
  # Extend ORM/ODMs for full support (:active_record included).
  config.extend_orms = [ :active_record ]

  # Use the plugin date/time parser which is stricter and extendable
  config.use_plugin_parser = true
end
