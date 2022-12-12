// Comp3005Project.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
//#include <sql.h>
using namespace std;

string escape(string input_for_sql)
{
    return input_for_sql;
}

int userLoop()
{
    string userCommand = "";
    string username = "";
    string shipAddress;
    string billAddress;
    int ISBN = 0;
    int orderqty = 0;
    string SQL = "";
    int userID;
    while (true)
    {
        cout << "Enter your username, or 'quit' to exit\n";
        cin >> username;
        if (username == "quit")
        {
            return 0;
        }
        username = "testname";
        //SQL = "SELECT * FROM user WHERE username = "+ username;
        //Exec_SQL(SQL);
        if (username == "testname")
        {
            cout << "Username exists. Starting book browsing\n";
            while (true)
            {
                cout << "Enter your selection. Options are: S(Search), N(New order), A(Add to Order), C(Checkout), Q(Quit)\n";
                cin >> userCommand;
                if (userCommand == "s" or userCommand == "S")
                {
                    cout << "What do you want to search books by? N(Name), A(Author), ISBN(I), Genre(G), Price(P)\n";
                    cin >> userCommand;
                    if (userCommand == "n" or userCommand == "N")
                    {
                        cout << "enter the name of the book you're searching for\n";
                        cin >> userCommand;
                        //SQL CALL GOES HERE
                    }
                    else if (userCommand == "a" or userCommand == "A")
                    {
                        cout << "enter the name of the author you're searching for\n";
                        cin >> userCommand;
                        //SQL CALL GOES HERE
                    }
                    else if (userCommand == "i" or userCommand == "I")
                    {
                        cout << "enter the ISBN you're searching for\n";
                        cin >> userCommand;
                        //SQL CALL GOES HERE
                    }
                    else if (userCommand == "g" or userCommand == "G")
                    {
                        cout << "enter the name of the genre you're searching for\n";
                        cin >> userCommand;
                        //SQL CALL GOES HERE
                    }
                    else if (userCommand == "p" or userCommand == "P")
                    {
                        cout << "enter the price you're searching for\n";
                        cin >> userCommand;
                        //SQL CALL GOES HERE
                    }
                    else
                    {
                        cout << "invalid input\n";
                    }
                }
                else if (userCommand == "n" or userCommand == "N")
                {
                    cout << "Enter the ship address of the new order\n";
                    cin >> shipAddress;
                    cout << "Enter the billing address of the new order\n";
                    cin >> billAddress;
                    //SQL CALL GOES HERE
                }
                else if (userCommand == "a" or userCommand == "A")
                {
                    cout << "Enter the ISBN of the book to add to the order";
                    cin >> userCommand;
                    //SQL CALL GOES HERE
                }
                else if (userCommand == "c" or userCommand == "C")
                {
                    //SQL CALL GOES HERE
                }
                else if (userCommand == "q" or userCommand == "Q")
                {
                    break();
                }
                else
                {
                    cout << "invalid selection\n";
                }
            }
        }
        else
        {
            cout << "This is a new username. Do you want to add it? Y(yes), any other key = no\n";
            cin >> userCommand;
            if (userCommand == "y" or userCommand == "Y")
            {
                cout << "Enter this user's Shipping Address\n";
                cin >> shipAddress;
                cout << "Next enter this user's Billing Address\n";
                cin >> billAddress;
            }
            else
            {
                cout << "okay, going back.";
            }
        }
    }
    return 0;
}

int ownerLoop()
{
    string ownerCommand = "";
    return 0;
}

int initialize()
{
    //SQL CALL GOES HERE
    return 0;
}

int main()
{
    string operationMode = "";
    int returncode = 0;
    while (true)
    {
        cout << "First, choose an operation mode. Options are I for Init (this generates the Database tables and need only be used once), U for User, O for Owner, or Q to Quit\n";
        cin >> operationMode;
        if (operationMode == "i" || operationMode == "I")
        {
            returncode = initialize();
        }
        if (operationMode == "u" || operationMode == "U")
        {
            cout << "User mode begins:\n";
            returncode = userLoop();
        }
        else if (operationMode == "o" || operationMode == "O")
        {
            cout << "Owner Mode begins:\n";
            returncode = ownerLoop();
        }
        else if (operationMode == "q" || operationMode == "Q")
        {
            cout << "quitting";
            return 0;
        }
        else
        {
            cout << "invalid option '" + operationMode + "'";
        }
    }
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
