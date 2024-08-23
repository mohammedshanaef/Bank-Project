import 'dart:io';

const String ClientsFileName = 'Clients.txt';

void showMainMenu() {
  print('===========================================');
  print('\t\tMain Menu Screen');
  print('===========================================');
  print('\t[1] Show Client List.');
  print('\t[2] Add New Client.');
  print('\t[3] Delete Client.');
  print('\t[4] Update Client Info.');
  print('\t[5] Find Client.');
  print('\t[6] Transactions.');
  print('\t[7] Exit.');
  print('===========================================');
  performMainMenuOption(readMainMenuOption());
}

void showTransactionsMenu() {
  print('===========================================');
  print('\t\tTransactions Menu Screen');
  print('===========================================');
  print('\t[1] Deposit.');
  print('\t[2] Withdraw.');
  print('\t[3] Total Balances.');
  print('\t[4] Main Menu.');
  print('===========================================');
  performTransactionsMenuOption(readTransactionsMenuOption());
}

class Client {
  String accountNumber;
  String pinCode;
  String name;
  String phone;
  double accountBalance;
  bool markForDelete = false;

  Client({
    required this.accountNumber,
    required this.pinCode,
    required this.name,
    required this.phone,
    required this.accountBalance,
    this.markForDelete = false,
  });

  factory Client.fromLine(String line, {String separator = '#//#'}) {
    var data = line.split(separator);
    return Client(
      accountNumber: data[0],
      pinCode: data[1],
      name: data[2],
      phone: data[3],
      accountBalance: double.parse(data[4]),
    );
  }

  String toLine({String separator = '#//#'}) {
    return '$accountNumber$separator$pinCode$separator$name$separator$phone$separator$accountBalance';
  }
}

List<Client> loadClientsDataFromFile(String fileName) {
  var clients = <Client>[];

  var file = File(fileName);
  if (file.existsSync()) {
    var lines = file.readAsLinesSync();
    for (var line in lines) {
      clients.add(Client.fromLine(line));
    }
  }
  return clients;
}

void saveClientsDataToFile(String fileName, List<Client> clients) {
  var file = File(fileName);
  var sink = file.openWrite();
  for (var client in clients) {
    if (!client.markForDelete) {
      sink.writeln(client.toLine());
    }
  }
  sink.close();
}

bool clientExistsByAccountNumber(String accountNumber, String fileName) {
  var clients = loadClientsDataFromFile(fileName);
  for (var client in clients) {
    if (client.accountNumber == accountNumber) {
      return true;
    }
  }
  return false;
}

Client readNewClient() {
  print('Enter Account Number? ');
  var accountNumber = stdin.readLineSync()!;
  while (clientExistsByAccountNumber(accountNumber, ClientsFileName)) {
    print(
        '\nClient with [$accountNumber] already exists, Enter another Account Number? ');
    accountNumber = stdin.readLineSync()!;
  }

  print('Enter PinCode? ');
  var pinCode = stdin.readLineSync()!;
  print('Enter Name? ');
  var name = stdin.readLineSync()!;
  print('Enter Phone? ');
  var phone = stdin.readLineSync()!;
  print('Enter AccountBalance? ');
  var accountBalance = double.parse(stdin.readLineSync()!);

  return Client(
    accountNumber: accountNumber,
    pinCode: pinCode,
    name: name,
    phone: phone,
    accountBalance: accountBalance,
  );
}

void addDataLineToFile(String fileName, String dataLine) {
  var file = File(fileName);
  var sink = file.openWrite(mode: FileMode.append);
  sink.writeln(dataLine);
  sink.close();
}

void addNewClient() {
  var client = readNewClient();
  addDataLineToFile(ClientsFileName, client.toLine());
}

void addNewClients() {
  var addMore = 'Y';
  do {
    print('Adding New Client:\n\n');
    addNewClient();
    print(
        '\nClient Added Successfully, do you want to add more clients? Y/N? ');
    addMore = stdin.readLineSync()!.toUpperCase();
  } while (addMore == 'Y');
}

void printClientRecordLine(Client client) {
  print('| ${client.accountNumber.padRight(15)}'
      '| ${client.pinCode.padRight(10)}'
      '| ${client.name.padRight(40)}'
      '| ${client.phone.padRight(12)}'
      '| ${client.accountBalance.toStringAsFixed(2).padRight(12)}');
}

void printClientRecordBalanceLine(Client client) {
  print('| ${client.accountNumber.padRight(15)}'
      '| ${client.name.padRight(40)}'
      '| ${client.accountBalance.toStringAsFixed(2).padRight(12)}');
}

void showAllClientsScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);

  print('\n\t\t\t\t\tClient List (${clients.length}) Client(s).');
  print('_______________________________________________________');
  print('_________________________________________\n');
  print('| ${'Account Number'.padRight(15)}'
      '| ${'Pin Code'.padRight(10)}'
      '| ${'Client Name'.padRight(40)}'
      '| ${'Phone'.padRight(12)}'
      '| ${'Balance'.padRight(12)}');
  print('_______________________________________________________');
  print('_________________________________________\n');

  if (clients.isEmpty) {
    print('\t\t\t\tNo Clients Available In the System!');
  } else {
    for (var client in clients) {
      printClientRecordLine(client);
      print('');
    }
  }

  print('_______________________________________________________');
  print('_________________________________________\n');
}

void showTotalBalances() {
  var clients = loadClientsDataFromFile(ClientsFileName);

  print('\n\t\t\t\t\tBalances List (${clients.length}) Client(s).');
  print('_______________________________________________________');
  print('_________________________________________\n');
  print('| ${'Account Number'.padRight(15)}'
      '| ${'Client Name'.padRight(40)}'
      '| ${'Balance'.padRight(12)}');
  print('_______________________________________________________');
  print('_________________________________________\n');

  var totalBalances = 0.0;
  if (clients.isEmpty) {
    print('\t\t\t\tNo Clients Available In the System!');
  } else {
    for (var client in clients) {
      printClientRecordBalanceLine(client);
      totalBalances += client.accountBalance;
      print('');
    }
  }

  print('_______________________________________________________');
  print('_________________________________________\n');
  print('\t\t\t\t\t   Total Balances = $totalBalances');
}

String readClientAccountNumber() {
  print('\nPlease enter AccountNumber? ');
  return stdin.readLineSync()!;
}

bool findClientByAccountNumber(
    String accountNumber, List<Client> clients, Client client) {
  for (var c in clients) {
    if (c.accountNumber == accountNumber) {
      client = c;
      return true;
    }
  }
  return false;
}

Client changeClientRecord(String accountNumber) {
  print('\n\nEnter PinCode? ');
  var pinCode = stdin.readLineSync()!;
  print('Enter Name? ');
  var name = stdin.readLineSync()!;
  print('Enter Phone? ');
  var phone = stdin.readLineSync()!;
  print('Enter AccountBalance? ');
  var accountBalance = double.parse(stdin.readLineSync()!);

  return Client(
    accountNumber: accountNumber,
    pinCode: pinCode,
    name: name,
    phone: phone,
    accountBalance: accountBalance,
  );
}

bool markClientForDeleteByAccountNumber(
    String accountNumber, List<Client> clients) {
  for (var c in clients) {
    if (c.accountNumber == accountNumber) {
      c.markForDelete = true;
      return true;
    }
  }
  return false;
}

bool deleteClientByAccountNumber(String accountNumber, List<Client> clients) {
  var client = Client(
      accountNumber: '', pinCode: '', name: '', phone: '', accountBalance: 0);
  if (findClientByAccountNumber(accountNumber, clients, client)) {
    print('\n\nAre you sure you want delete this client? y/n ? ');
    var answer = stdin.readLineSync()!.toLowerCase();
    if (answer == 'y') {
      markClientForDeleteByAccountNumber(accountNumber, clients);
      saveClientsDataToFile(ClientsFileName, clients);
      print('\n\nClient Deleted Successfully.');
      return true;
    }
  } else {
    print('\nClient with Account Number ($accountNumber) is Not Found!');
    return false;
  }
  return false;
}

bool updateClientByAccountNumber(String accountNumber, List<Client> clients) {
  var client = Client(
      accountNumber: '', pinCode: '', name: '', phone: '', accountBalance: 0);
  if (findClientByAccountNumber(accountNumber, clients, client)) {
    client = changeClientRecord(accountNumber);
    markClientForDeleteByAccountNumber(accountNumber, clients);
    clients.add(client);
    saveClientsDataToFile(ClientsFileName, clients);
    print('\n\nClient Updated Successfully.');
    return true;
  } else {
    print('\nClient with Account Number ($accountNumber) is Not Found!');
    return false;
  }
}

void showDeleteClientScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);
  var accountNumber = readClientAccountNumber();
  deleteClientByAccountNumber(accountNumber, clients);
}

void showUpdateClientScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);
  var accountNumber = readClientAccountNumber();
  updateClientByAccountNumber(accountNumber, clients);
}

void showFindClientScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);
  var accountNumber = readClientAccountNumber();
  var client = Client(
      accountNumber: '', pinCode: '', name: '', phone: '', accountBalance: 0);
  if (findClientByAccountNumber(accountNumber, clients, client)) {
    printClientRecordLine(client);
  } else {
    print('\nClient with Account Number ($accountNumber) is Not Found!');
  }
}

void deposit(Client client) {
  print('\nEnter Deposit Amount: ');
  var amount = double.parse(stdin.readLineSync()!);
  client.accountBalance += amount;
  print('\nAmount Deposited Successfully.');
}

void withdraw(Client client) {
  print('\nEnter Withdraw Amount: ');
  var amount = double.parse(stdin.readLineSync()!);
  if (amount <= client.accountBalance) {
    client.accountBalance -= amount;
    print('\nAmount Withdrawn Successfully.');
  } else {
    print('\nNot enough balance.');
  }
}

void showDepositScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);
  var accountNumber = readClientAccountNumber();
  var client = Client(
      accountNumber: '', pinCode: '', name: '', phone: '', accountBalance: 0);
  if (findClientByAccountNumber(accountNumber, clients, client)) {
    deposit(client);
    saveClientsDataToFile(ClientsFileName, clients);
  } else {
    print('\nClient with Account Number ($accountNumber) is Not Found!');
  }
}

void showWithdrawScreen() {
  var clients = loadClientsDataFromFile(ClientsFileName);
  var accountNumber = readClientAccountNumber();
  var client = Client(
      accountNumber: '', pinCode: '', name: '', phone: '', accountBalance: 0);
  if (findClientByAccountNumber(accountNumber, clients, client)) {
    withdraw(client);
    saveClientsDataToFile(ClientsFileName, clients);
  } else {
    print('\nClient with Account Number ($accountNumber) is Not Found!');
  }
}

void showEndScreen() {
  print('\nProgram Ends :-)');
}

int readMainMenuOption() {
  print('Choose what do you want to do? [1 to 7]? ');
  return int.parse(stdin.readLineSync()!);
}

int readTransactionsMenuOption() {
  print('Choose what do you want to do? [1 to 4]? ');
  return int.parse(stdin.readLineSync()!);
}

void performMainMenuOption(int choice) {
  switch (choice) {
    case 1:
      showAllClientsScreen();
      break;
    case 2:
      addNewClients();
      break;
    case 3:
      showDeleteClientScreen();
      break;
    case 4:
      showUpdateClientScreen();
      break;
    case 5:
      showFindClientScreen();
      break;
    case 6:
      showTransactionsMenu();
      break;
    case 7:
      showEndScreen();
      break;
    default:
      print('Invalid option, please try again.');
      showMainMenu();
  }
}

void performTransactionsMenuOption(int choice) {
  switch (choice) {
    case 1:
      showDepositScreen();
      break;
    case 2:
      showWithdrawScreen();
      break;
    case 3:
      showTotalBalances();
      break;
    case 4:
      showMainMenu();
      break;
    default:
      print('Invalid option, please try again.');
      showTransactionsMenu();
  }
}

void main() {
  showMainMenu();
}
