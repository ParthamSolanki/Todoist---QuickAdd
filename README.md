# Why?
The todoist windows app felt really bulky since I just use it for its quick add functionality, that Ctrl+Space which open a window to quickly add task.

# How it works?
1. You store you todoist api key in a text file named "api_token.txt", you can use any name but you will have to change that in the script too. The todoist api key can be found in Todoist Settings > Integrations > Developer > Copy API token
2. Just download the script and keep it along with the api token file, if you want the script to run at startup, paste both these files in the startup folder.
3. Now uninstall todoist (if you have it) and when you press enter, it will open a window for adding text.
4. You will get popups for `#` and `@` which you can change from the script in line 32 and 33 as you need (just copy from you actual todoist account for consistency). You can also add more than 2, just follow the standard scheme from the script.
5. Beware that this script though fully functional can't replicate the todoist quick add windows completely.

# Quirks
1. It doesn't shift to the drop down for using arrow keys, you can use tab or mouse or touchpad to navigate, I was initially going for this but then thought to keep it in a way where I just type and the drop down shows suggestions which get inputted in the main text field when pressing enter.
2. It will give a popup that task added on successful sending of task to the todoist api endpoint, I used the one where natural language processing is enabled so when you input mon, or any other stuff that works in todoist it will work here too, there was another endpoint where just the raw text was placed in the inbox as a task without NLP which I don't think is better for use here.
3. Used a dark theme, I abhor light themes. Just change the color hexcodes for the text and all if you want light theme.

# What doesn't work?
1. For some weird reason when you press Ctrl+Backspace it input a weird rectangle shape rather than delete the whole word. I frankly don't know why this is happening.
