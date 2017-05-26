# Full Stack Developer – Code Challenge

Design and code JSON API endpoints in the latest Rails.

#### A user (user_1) (inviter) should be able to

* Create a meeting specifying a place, date, and time
* Generate unique url for an invitation that will allow a user to access the meeting

#### A user (user_(1+n)) (invitee) should be able to
* Retrieve information about a meeting or invitation if they have an invitation
* Take action on the invitation
* Check the status of an invitation they received (accepted, declined, etc)

#### Bonus points

* Specify the maximum number of people that may accept before the meeting is overbooked
    * When the maximum number of acceptances is reached, the meeting is fully booked, one more and it would be overbooked.
* Close off any fully booked meetings to anyone that has not yet accepted
    * The invitation must be accepted to count towards the meetings attandance.

#### Even more points

* Enable an invitation to have recurring rules, eg. Every Wednesday from today until a month from now.
* Allow a user to only accept one instance of a recurring meeting.

Please commit often and tell a story of your process with your commit history.