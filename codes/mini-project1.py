# http://www.codeskulptor.org/#user29_u9ttL048UF_13.py
# Rock-paper-scissors-lizard-Spock template


# The key idea of this program is to equate the strings
# "rock", "paper", "scissors", "lizard", "Spock" to numbers
# as follows:
#
# 0 - rock
# 1 - Spock
# 2 - paper
# 3 - lizard
# 4 - scissors

# helper functions

import random

def name_to_number(name):
    if(name == "rock"):
        return 0
    elif(name == "Spock"):
        return 1
    elif(name == "paper"):
        return 2
    elif(name == "lizard"):
        return 3
    elif(name == "scissors"):
        return 4
    else:
        print "Incorrect name provided: " + name
        return -1

def number_to_name(number):
    if(number == 0):
        return "rock"
    elif(number == 1):
        return "Spock"
    elif(number == 2):
        return "paper"
    elif(number == 3):
        return "lizard"
    elif(number == 4):
        return "scissors"
    else:
        print "Incorrect number provided: " + number
        return -1
    

def rpsls(player_choice): 
    print
    
    # print out the message for the player's choice
    print "Player chooses " + player_choice

    # convert the player's choice to player_number using the function name_to_number()
    player_number = name_to_number(player_choice)
   
    if(player_number == -1):
        return

    # compute random guess for comp_number using random.randrange()
    comp_number = random.randrange(0, 5)

    # convert comp_number to comp_choice using the function number_to_name()
    computer_choice = number_to_name(comp_number)
    
    # print out the message for computer's choice
    print "Computer chooses " + computer_choice

    # compute difference of comp_number and player_number modulo five
    diff = (comp_number % 5) - (player_number % 5)

    # use if/elif/else to determine winner, print winner message
    if(diff == 0):
        print "Player and computer tie!"
    elif(diff > 2):
        print "Player wins!"            
    elif(diff < -2):
        print "Computer wins!"        
    elif(diff > 0 & diff <= 2):
        if(comp_number > player_number):
            print "Computer wins!"
        else:
            print "Player wins!"
    elif(diff < 0 & diff >= -2):
        if(comp_number > player_number):
            print "Computer wins!"
        else:
            print "Player wins!"
    else:
        print "..."

# test your code - LEAVE THESE CALLS IN YOUR SUBMITTED CODE
rpsls("rock")
rpsls("Spock")
rpsls("paper")
rpsls("lizard")
rpsls("scissors")

# always remember to check your completed program against the grading rubric