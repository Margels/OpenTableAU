# OpenTableAU
## Assignment
Build an iPhone app which allows restaurant staff to create and view reservations for the day.


https://user-images.githubusercontent.com/89708428/173964514-74fbd374-cc91-4daf-b568-55e212664efd.mp4


## Requirements
* The app should launch to the Reservations screen.
* The Reservations screen should display all of the day’s reservations in a scrollable list,
sorted by reservation time.
* * Each reservation cell should display the party size, name, and reservation time.
* Tapping a reservation cell on the Reservations screen should take the user to the
Reservation Details screen and display the reservation details shown in the wireframe
above.
* Tapping the Create button on the Reservations screen should enter the Create flow,
beginning with the Select Time screen.
* The Select Time screen should show all time slots between 3 PM and 10 PM (inclusive),
in 15-minute intervals in a scrollable list.
* * Time slots already consumed by an existing (60-minute long) reservation should
display “Not Available” and should not be selectable by the user.
* * Time slots with availability should be selectable.
* * Availability should be based on a restaurant that only has a single table (i.e., it
cannot host more than one party at any given time) and reservation durations are
always 60 minutes.
* Tapping on an available time slot on the Select Time screen should navigate to the
Select Party Size screen.
* The Select Party Size screen should show party sizes 1 through 5.
* Tapping on a party size should navigate to the Guest Details screen.
* The Guest Details screen should collect the following information:
* * Name - A single-line text field that must contain at least one character.
* * Phone number - A single-line optional text field that doesn’t need to do any
special formatting or validation.
* * Visit notes - A multi-line optional text field.
* Tapping the Save button should save the reservation, exit the Create flow, and take the
user back to the Reservations screen.
* * After saving the reservation, the list of reservations should automatically scroll so
that the newly created reservation is within view.
* While in the Create flow, the user should be allowed to navigate back to a previous
screen in the flow to make changes.
* Empty states and validation errors should be handled elegantly.

## Assumptions
- The restaurant is able to seat reservations between 3 PM and 10 PM and only at
15-minute intervals. (e.g., 3:10 PM is not a legal reservation time, but 3:15 PM and
3:30 PM are.)
- This is a very exclusive restaurant with only one reservable table.
- Every reservation is assumed to be 60 minutes long.
- The largest party size this table can seat is five. The minimum party size is one.
- To keep things simple, the app is only concerned with a single day’s worth of
reservations and therefore does not require any date considerations. App behavior
when the date transitions to the next day at midnight will not be evaluated for this
exercise.
- To keep things simple, it’s okay if restaurant staff need to re-enter reservations
between app sessions. Data persistence is not required.
- To keep things simple, it’s okay if we don’t do any phone number formatting or
validation.
