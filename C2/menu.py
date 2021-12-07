#!/usr/bin/env python3
import os, logging
import app_logging
from crud_resources import *
from createDB import *

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
            userMenu()
        elif choice == '2' :
            print(f'\nChoice: {choice}')
            resourcesMenu()
        elif choice == '3' :
            print(f'\nChoice: {choice}')
            rolesMenu()
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '0':
            print(f'\nChoice: {choice}')
            con.close()
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
        1 : Create company resource                             (DONE)
        2 : Update/Modify company resource
        3 : Delete company resource                             (DONE)
        4 : List which users have access to a specific resource
        5 : List resources that contain "input" in the name     (DONE)
        6 : List all resources                                  (DONE)
        7 : Return to main menu
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            # Create new resource, gets input from user
            resource = input("\nName of the resource to create:")
            insert_resource(con,(resource,))
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            # Delete a resource, gets input from user
            resource = input("\nName of the resource to delete: ")
            varQuestionDelete = input(f"\nAre you sure you want to delete resource: {resource}? (Y/N)")
            if varQuestionDelete in ('y', 'yes', 'Y', 'YES'):
                delete_resource(con,(resource,))
                # Delete operation requires a commit, so that when the connection is closed to the DB the resource is actually deleted
                con.commit()
            else:
                print(f'\Resource: {resource}, not deleted')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '5' :
            # Print resources that contain "{resource}"
            resource = input("\nList of resources that contain:")
            print(f'\n### List of resources that contain "{resource}" in the name###')
            resource = "%"+resource+"%"
            results = list_resource(con,(resource,))
            for row in results:
                print(row[0])
        elif choice == '6' :
            # Print all resources
            print(f'\n### List of all resources ###')
            results = list_resource(con,"ALL")
            for row in results:
                print(row[0])
        elif choice == '7' :
            # Return to main menu
            print(f'\nChoice: {choice}')
            mainMenu()
        elif choice == '0':
            # Exit the script
            print(f'\nChoice: {choice}')
            con.close()
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
            con.close()
            exit()
        else:
            print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

### Script execution ###

# Connect to database
try:
    con = sqlite3.connect('example.db')
    createTables(con)
except:
    print("Not possible to connect to database")

# Calling main menu function
logging.info('### INFO - Starting script ###\n')
mainMenu()