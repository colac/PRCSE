#!/usr/bin/env python3
import os, logging
import app_logging
from datetime import datetime, timezone, timedelta
from crud_resources import *
from createDB import *
from crud_users import *
from crud_roles import *
from crud_user_roles import *

# Create the timestamp in miliseconds, used for password expiration date
def converto_to_ms(days_valid):
    # Convert number of days, currently a string, to int
    days_valid = int(days_valid)
    # The method "strptime" creates a datetime object from the given string. This string is created using "strftime"
    # Creating the current date string, like "2021-12-08"
    current_date = datetime.strptime(datetime.now(timezone.utc).strftime("%Y%m%d"),'%Y%m%d')
    # Creates the expiration date string. "timedelta" is a class that allows the input of a duration, expressing the difference between two dates, in our case the variable "days" 
    expiration_date = current_date + timedelta(days=days_valid)
    # Convert date to miliseconds
    expiration_milisec_date = expiration_date.timestamp() * 1000
    return expiration_milisec_date

# Convert the timestamp in miliseconds to date, used for password expiration
def converto_from_ms(date_to_convert):
    # Convert value received, currently a string, to int
    date_to_convert = int(date_to_convert)
    # Convert from miliseconds to date Year-Month-Day HH:MM:SS
    date_converted = datetime.fromtimestamp(date_to_convert/1000.0)
    # Show only Year-Month-Day, removing HH:MM:SS
    date_converted = date_converted.strftime('%Y-%m-%d')
    return date_converted

# Main menu, the 1st menu the operator sees
def mainMenu():
    error=""
    while True:
        os.system("clear") # VM
        # Used to print messages to the user after executing an actions
        print(error)
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
            #os.system("clear")
            error=f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!' #VM
            #print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# User menu, perform operations related to user accounts
def userMenu():
    error=""
    while True:
        os.system("clear")
        print(error)
        print("\nChoose an option: ")
        print("""
        1 : Create user account
        2 : Update/Modify user account
        3 : Delete user account
        4 : List information of a user account
        5 : List information of all user accounts
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
            user = input('\nType user account name: ')
            # Get current values from the role in the DB
            results = find_user(con,(user,))
            print(f'\nUsername: {results[0]}; Name: {results[1]}; Bank Account Number: {results[2]}; Password valid for: {results[3]} days; Password expiration date: {results[4]}')
            input("\nPress <enter> to continue")
            userMenu()
        elif choice == '5' :
            print(f'\nChoice: {choice}')
            # Print all roles
            print(f'\n### List of all user accounts ###')
            results = list_user(con,"ALL")
            for row in results:
                print(f'\nUsername: {row[0]}; Name: {row[1]}; Bank Account Number: {row[2]}; Password valid for: {row[3]} days; Password expiration date: {row[4]}')
            input("\nPress <enter> to continue")
            userMenu()
        elif choice == '6' :
            mainMenu()
        elif choice == '0':
            print(f'\nChoice: {choice}')
            con.close()
            exit()
        else:
            error=f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!'
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# Resources menu, perform operations related to resources
def resourcesMenu():
    error=""
    while True:
        os.system("clear")
        # Used to print messages to the user after executing an actions
        print(error)
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
            error = insert_resource(con,(resource,))
            if error == "OK":
                error = "Resource " + resource + " created successfully"
        elif choice == '2' :
            print(f'\nChoice: {choice}')
        elif choice == '3' :
            # Delete a resource, gets input from user. Before deleting checks if it exists in DB
            resource = input("\nName of the resource to delete: ")
            varQuestionDelete = input(f"\nAre you sure you want to delete resource: {resource}? (Y/N)")
            if varQuestionDelete in ('y', 'yes', 'Y', 'YES'):
                varFind_resource = find_resource(con,(resource,))
                if varFind_resource[0] == resource:
                    delete_resource(con,(resource,))
                    # Delete operation requires a commit, so that when the connection is closed to the DB the resource is actually deleted
                    con.commit()
                    print(f'Resource: {resource}, deleted')
                    logging.info(f'### INFO - Resource: {resource}, deleted ###\n')
                else:
                    print(f'{resource}, is not a resource!')
            else:
                print(f'Resource: {resource}, not deleted')
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
            input("Press <enter> to continue")
        elif choice == '6' :
            # Print all resources
            print(f'\n### List of all resources ###')
            results = list_resource(con,"ALL")
            for row in results:
                print(row[0])
            input("Press <enter> to continue")
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
            error=f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!'
            #print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
            logging.error(f'ERROR - Choice: {choice} is NOT valid!')

# Roles menu, perform operations related to roles
def rolesMenu():
    error=""
    while True:
        os.system("clear")
        # Used to print messages to the user after executing an actions
        print(f"{error}")
        print("\nChoose an option: ")
        print("""
        1 : Create a role                           (DONE)
        2 : Update/Modify a role                    (DONE)
        3 : Delete role                             (DONE)
        4 : List which users have a specific role
        5 : List all roles                          (DONE)
        6 : Return to main menu
        0 : Exit"""
              )
        choice = input("\nEnter your choice : ")

        if choice == '1':
            # Create new role, gets input from user
            role_name = input(f'\nName of the role to create (Ex.: roleName_resourceName_permission): ')
            role_resource = input(f'\nName of the resource this role, "{role_name}", will grant access: ')
            role_permission = input(f'\nPermissions of the role, "{role_name}"", on the resource, "{role_resource}" (Values:"R" or "RW"): ')
            # Check if the permission entered is valid
            if role_permission in ('r', 'R', 'rw', 'RW'):
                role = (role_name,role_resource,role_permission)
                error = insert_role(con,role)
            else:
                error = f'Role permission "{role_permission}" is not valid!'
            if error == "OK":
                error = f'Role "{role_name}" created successfully.'
                logging.info(f'### INFO - Role: {role_name}, created successfully. ###\n')
        elif choice == '2' :
            # Change role, gets input from user
            role_name_current = input('\nName of the role to modify: ')
            # Get current values from the role in the DB
            result = find_role(con,(role_name_current,))
            role_resource_current = result[1]
            role_permission_current = result[2]
            # Get new name for the role, or keep the same by hitting enter
            # In case the user doesn't write anything, we save this variable to use later
            role_name = input(f'\nNew name of the role (To keep the current name "{role_name_current}", just hit "Enter" button): ')
            if not role_name.isspace() and not role_name.strip():
                print("Nothing written for roleName")
                role_name = role_name_current
            # Get new resource for the role, or keep the same by hitting enter
            role_resource = input(f'\nName of the resource this role, will grant access (To keep the current resource "{role_resource_current}", just hit "Enter" button): ')
            if not role_resource.isspace() and not role_resource.strip():
                role_resource = role_resource_current
            # Get new permission for the role, or keep the same by hitting enter
            role_permission = input(f'\nPermissions of the role, "{role_name}", on the resource, "{role_resource_current}" (Values:"R", "W" or "RW"): ')
            if not role_permission.isspace() and not role_permission.strip():
                role_permission = role_permission_current
            # Check if the permission entered is valid
            if role_permission in ('r', 'R', 'w', 'W', 'rw', 'RW'):
                role = (role_name,role_resource,role_permission,role_name_current)
                error = update_role(con,role)
            else:
                error = f'Role permission "{role_permission}" is not valid!'
            if error == "OK":
                error = f'Role "{role_name}" updated successfully.'
                logging.info(f'### INFO - Role: {role_name_current}, updated successfully. {role_name} {role_resource} {role_permission} ###\n')
        elif choice == '3' :
            # Delete a role, gets input from user. Before deleting checks if it exists in DB
            role = input("\nName of the role to delete: ")
            varQuestionDelete = input(f"\nAre you sure you want to delete role: {role}? (Y/N)")
            if varQuestionDelete in ('y', 'yes', 'Y', 'YES'):
                varFind_role = find_role(con,(role,))
                if varFind_role[0] == role:
                    delete_role(con,(role,))
                    # Delete operation requires a commit, so that when the connection is closed to the DB the role is actually deleted
                    con.commit()
                    error = f'Role: "{role}", deleted'
                    logging.info(f'### INFO - role: {role}, deleted ###\n')
                else:
                    print(f'{role}, is not a role!')
            else:
                print(f'Role: {role}, not deleted')
        elif choice == '4' :
            print(f'\nChoice: {choice}')
        elif choice == '5' :
            # Print all roles
            print(f'\n### List of all roles ###')
            results = list_role(con,"ALL")
            for row in results:
                print(row[0])
            input("\nPress <enter> to continue")
            rolesMenu()
        elif choice == '6' :
            mainMenu()
        elif choice == '0':
            print(f'\nChoice: {choice}')
            con.close()
            exit()
        else:
            error=f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!'
            #print(f'\n[ERROR] - Please insert a valid option. Choice: {choice} is NOT valid!')
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
