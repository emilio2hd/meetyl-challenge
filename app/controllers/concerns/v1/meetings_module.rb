module V1::MeetingsModule
  extend Apipie::DSL::Concern

  def_param_group :meeting do
    param :meeting, Hash, desc: 'Meeting info', required: true do
      param :place, String, desc: 'Meeting place', required: true
      param :date, Date, desc: 'Meeting date', required: true
      param :time, Time, desc: 'Meeting time', required: true
      param :maximum_participants, Integer, desc: 'Meeting maximum of participants'
    end
  end

  api :GET, '/users/:user_id/meetings', 'List all user meetings either as creator or as invitee'
  api_version 'v1'
  def index; end

  api :POST, '/users/:user_id/meetings', 'Create a meeting specifying a place, date, and time'
  error code: 400, desc: 'The meeting has validation errors'
  api_version 'v1'
  param_group :meeting
  def create; end

  api :GET, '/users/:user_id/meetings/:id', 'Get a meeting information'
  error code: 404, desc: 'The meeting was not found'
  api_version 'v1'
  def show; end

  api :PUT, '/users/:user_id/meetings/:id', 'Update meeting information'
  error code: 400, desc: 'The meeting has validation errors'
  error code: 404, desc: 'The meeting was not found'
  api_version 'v1'
  param_group :meeting
  def update; end

  api :POST, '/users/:user_id/meetings/:id/invite', 'Invite an user to a meeting'
  error code: 400, desc: 'The invitation has validation errors'
  error code: 404, desc: 'The meeting was not found'
  api_version 'v1'
  param :invitation, Hash, desc: 'Invitation info', required: true do
    param :invitee_id, Integer, desc: 'User invitee id', required: true
    param :recurrence, Hash, desc: 'Invitation recurrence' do
      param :type, String, desc: 'Recurrence type', required: true
      param :start_time, DateTime, desc: 'When the recurrence should start'
      param :end_time, DateTime, desc: 'When the recurrence should end'
      param :options, Hash, desc: 'Recurrence options' do
        param :interval, Integer, desc: 'Recurrence interval'
        param :day, Array, of: String, desc: 'The weekday name(s)'
        param :day_of_month, Array, of: Integer, desc: 'The day(s) of the month'
        param :day_of_week, Hash, desc: 'The weekday name(s) and its position(s) on month (1st Tuesday, 2nd Monday)'
        param :day_of_year, Array, of: Integer, desc: 'The day(s) of the year'
        param :month_of_year, Array, of: String, desc: 'The month(s) name'
      end
    end
  end
  meta :recurrence => {
    :type => 'daily, weekly, monthly, yearly',
    :options => {
      :day => '[monday, tuesday, wednesday, thursday, friday, saturday, sunday]',
      :day_of_week => '[monday, tuesday, wednesday, thursday, friday, saturday, sunday]',
      :month_of_year => '[january, february, march, april, may, june, july, august, september, october, november, december]'
    }
  }
  description <<-EOS
== How to Specify Invitation Recurrence
You can specify the recurrence through the <tt>{ invitation: { recurrence: {} }}</tt>

=== Daily
Daily:: <tt>recurrence: { type: 'daily' }</tt>
Every 3 days:: <tt>recurrence: { type: 'daily', options: { interval: 3 } }</tt>

=== Weekly
Weekly:: <tt>recurrence: { type: 'weekly' }</tt>
Every 2 weeks:: <tt>recurrence: { type: 'weekly', options: { interval: 2 } }</tt>
Weekly on Mondays:: <tt>recurrence: { type: 'weekly', options: { day: ['monday'] } }</tt>
Every 2 weeks on Mondays:: <tt>recurrence: { type: 'weekly', options: { interval: 2, day: ['monday'] } }</tt>

=== Monthly
Monthly:: <tt>recurrence: { type: 'monthly' }</tt>
Every 2 months:: <tt>recurrence: { type: 'monthly', options: { interval: 2 } }</tt>
Monthly on the 15th day of the month:: <tt>recurrence: { type: 'monthly', options: { day_of_month: [15] } }</tt>
Monthly on the 10th and 20th days of the month:: <tt>recurrence: { type: 'monthly', options: { day_of_month: [10, 20] } }</tt>
Monthly on the 1st Tuesday and last Tuesday:: <tt>recurrence: { type: 'monthly', options: { day_of_week: { tuesday: [1, -1] } } }</tt>
Every 2 months on the 1st Monday and last Tuesday:: <tt>recurrence: { type: 'monthly', options: { interval: 2, day_of_week: { monday: [1], tuesday: [-1] } } }</tt>

=== Yearly
Yearly:: <tt>recurrence: { type: 'yearly' }</tt>
Every 2 years:: <tt>recurrence: { type: 'yearly', options: { interval: 2 } }</tt>
Yearly on the 100th days from the beginning and end of the year:: <tt>recurrence: { type: 'yearly', options: { day_of_year: [100, -100] } }</tt>
Yearly in March:: <tt>recurrence: { type: 'yearly', options: { month_of_year: [:march] } }</tt>
Yearly in January and February:: <tt>recurrence: { type: 'yearly', options: { month_of_year: [:january, :february] } }</tt>
EOS
  def invite; end

  api :GET, '/meetings/:id/:access_code', 'Access a meeting'
  api_version 'v1'
  error code: 400, desc: 'The meeting has validation errors'
  error code: 404, desc: 'The meeting with access_code was not found'
  def access; end
end