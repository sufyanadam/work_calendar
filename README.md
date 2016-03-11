# WorkCalendar

A small, lean customizable ruby library to determine work days.

# Implementation
I was shooting for something that was super lean and super simple. So I test drove it according to the requirements provided. I started out with the `active?` method since that was the core of the implementation; all other behaviour relies on it somehow. Once completed I was able to use `active?` to implement the rest of the required behaviour.

# Considerations
 - I decided to use `OpenStruct` instead of a class to maintain the custom configuration because it helped make the code look simpler and shorter. All behaviour was heavily tested (Test Driven!) and using a class over `OpenStruct` made no difference in the behaviour. In the end I chose `OpenStruct` for the simplicity.

 - I added a method `reset_to_default_config!` as a means to avoid test pollution in my test suite. I didn't feel the need to unit test this method because the tests would fail pretty loudly anyway without a way to clear any customizations.

# Running the Tests
- clone the repo: `git clone https://github.com/sufyanadam/work_calendar`

- `cd /path/to/repo-you-just-cloned`

- `bundle`

- `rspec`