class RecurrenceValidator < ActiveModel::Validator
  def validate(record)
    record.respond_to? :recurrence
    return if !record.respond_to?(:recurrence) || record.recurrence.to_s.empty?

    @record = record

    check_recurrence_formation
    check_start_end_time
    check_supported_type
    check_rule_creation
  end

  private

  def check_recurrence_formation
    @recurrence_params = (Hash.try_convert(@record.recurrence) || {}).with_indifferent_access
    add_error('It must be a valid hash') if @recurrence_params.empty?
  end

  def check_start_end_time
    return if errors?

    try_convert_to_time(:start_time) { |time_parsed| @record.start_time = time_parsed }
    try_convert_to_time(:end_time) { |time_parsed| @record.end_time = time_parsed }

    return if errors? || @record.end_time.nil? || @record.start_time.nil?

    add_error('end_time must be higher than start_time') if @record.end_time <= @record.start_time
  end

  def try_convert_to_time(key_name)
    return unless @recurrence_params.key?(key_name)

    time_parsed = Time.zone.parse(@recurrence_params[key_name])
    raise ArgumentError if time_parsed.nil?

    yield(time_parsed) if block_given?
  rescue ArgumentError
    add_error("#{key_name} is not a valid datetime")
  end

  def check_supported_type
    if !errors? && !Recurrence::RuleCreator.creator?(@recurrence_params[:type])
      add_error("The type '#{@recurrence_params[:type]}' is not supported")
    end
  end

  def check_rule_creation
    @record.rule = Recurrence::RuleCreator.create(@recurrence_params) unless errors?
  rescue ArgumentError
    add_error('Recurrence options lead to a malformed recurrence')
  end

  def add_error(message)
    @record.errors.add(:recurrence, message)
  end

  def errors?
    !@record.errors[:recurrence].size.zero?
  end
end