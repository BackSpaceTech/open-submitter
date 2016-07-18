# Submitting to Services

Once you have set up Open Submitter:
- prequesite frameworks installed and tested
- article submission file has been created and saved to the articles folder
- accounts csv file created and saved to accounts folder
- indexing service file created and saved to settings folder

You can now start the submit service.

## Starting the Submit Service

The submit service must be started through the Command Line Interface (CLI). Open a command console (we recommend using the free app [Cmder][35fd80d0] if you are using Windows) and navigate to the Open Submitter directory.

![](./img/submit.PNG)

![](./img/submit2.PNG)


To start the service run the following casperjs command:
- casperjs (the headless webkit service)
- open-submitter.js (Open Submitter application)
- the name of your accounts file without the file extension
- the name of your article submission file without the file extension
- the file name to store backlinks to without the file extension
- number of submission loops. e.g. if you have 20 accounts per service you may want to submit 5 randomly per day.

e.g.

casperjs casperjs open-submitter.js accounts articles backlinks 5


The submit service will now start submitting the article to the services.

![](./img/submit3.PNG)



## Enabling and Disabling Services

Not all services are reliable and many seem to be down more than they are up.



  [35fd80d0]: http://cmder.net/ "Cmder Console"
