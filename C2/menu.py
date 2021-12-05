#!/usr/bin/env python3
import os, logging
import app_logging

# Main menu, the 1st menu the operator sees
def mainMenu():
    while True:
        #os.system("clear")
        print("\nChoose an option: ")
        print("""
        1 : User accounts actions (leads to another menu with create/delete/modify/list)
        2 : Company resources actions (leads to another menu with create/delete/modify/list)
        3 : Roles actions (leads to another menu with create/delete/modify/list)
        4 : List all information
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            print(f'\nChoice: {choice}')
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            print(f'\nChoice: {choice}')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '0':
            print(f'\nChoice: {choice}')
            exit()
        else:
            os.system("clear")
            print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# User menu, perform operations related to user accounts
def userMenu():
    while True:
        #os.system("clear")
        print("\nChoose an option: ")
        print("""
        1 : Create user account
        2 : Update/Modify user account
        3 : Delete user account
        4 : List information for a user account
        5 : Return to main menu
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            print(f'\nChoice: {choice}')
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            print(f'\nChoice: {choice}')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '5' :
            print(f'\nChoice: {choice}')
            mainMenu()
        elif choice == '0':
            print(f'\nChoice: {choice}')
            exit()
        else:
            print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# Resources menu, perform operations related to resources
def resourcesMenu():
    while True:
        #os.system("clear")
        print("\nChoose an option: ")
        print("""
        1 : Create company resource
        2 : Update/Modify company resource
        3 : Delete company resource
        4 : List which users have access to a specific resource
        5 : List all resources
        6 : Return to main menu
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            print(f'\nChoice: {choice}')
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            print(f'\nChoice: {choice}')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '5' :
            print(f'\nChoice: {choice}')
            mainMenu()
        elif choice == '0':
            print(f'\nChoice: {choice}')
            exit()
        else:
            print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# Roles menu, perform operations related to roles
def rolesMenu():
    while True:
        #os.system("clear")
        print("\nChoose an option: ")
        print("""
        1 : Create a role
        2 : Update/Modify a role
        3 : Delete role
        4 : List which users have a specific role
        5 : List all roles
        6 : Return to main menu
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            #aws.aws()
            print(f'\nChoice: {choice}')
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            print(f'\nChoice: {choice}')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '5' :
            print(f'\nChoice: {choice}')
            mainMenu()
        elif choice == '0':
            print(f'\nChoice: {choice}')
            exit()
        else:
            print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# Calling main menu function
logging.info('### INFO - Starting script ###\n')
mainMenu()