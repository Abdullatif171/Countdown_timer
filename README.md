# Countdown_timer
 Countdown_timer with flutter using Provider
- Android and iOS compatible without extra libraries
- In a PageView() with 5 pages of the scheduler
- Updating the scheduler with Provider()
- Each page has an independent timer that counts down independently of the other pages.
- The countdown can be adjusted by tapping the timer on the pages.
- switching between pages does not stop or reset the timer.
- There are three files:

main.dart
pager_setup.dart
this is the page that sets up PageView()
this page is the page where countdown timers are set
coundown_page.dart
This page has a PageView and a large TextView in the center of each page in page view. Each text is a countdown timer. Touching the countdown timer starts the countdown.
Turning the page does not stop or reset the countdown.
