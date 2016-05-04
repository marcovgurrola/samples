# Inside the setup folder, OSX or ubuntu, are detailed instructions
# to INSTALL the required packages:
install.txt
  1 Database (postgress)
  2 Server (node + npm)
  3 Market Research System (Application)

# Detailed instructions to *UNINSTALL the installed packages:
- uninstall.txt	


# START the application
- Navigate to marketsurveyapi/app folder
	cd ....marketsurveyapi/app folder
- Start:
	node scripts/server.js
	sudo node scripts/server.js
- Stop
	ctrl c


# USAGE

  There are 3 surveys, with 3 different subjects (UNSPSC kind code):
  PP for Purchasing Power
  FE for Family Expenses
  AS for Advertising strategies

  -On the Web Browser, requests examples:
  
  All surveys:          	/surveys
  By subject:           	/subject/:PP
  By Conducting party:  	/surveys/party/:Tlaloc
                        	/surveys/party/:Tlaloc%20Bank


  Interactive GUI
  (Subscribed/Refresh) 	/fancy

  **Automatically unsubscribed on Page Reload



  -Curl, from the shell terminal, base url is marketresearch.ddns.net,
  for local test is localhost:

  curl --request GET 'http://localhost/surveys' --include
  curl --request GET 'http://localhost/subject/:PP' --include
  curl --request GET 'http://localhost/surveys/party/:Tlaloc' --include
  curl --request GET 'http://localhost/surveys/party/:Tlaloc%20Bank' --include

