import static javax.swing.JOptionPane.*;
import java.time.LocalDate;
///comment
String nameofcenter= "Bishoftu General Hospital";
String choose; 
String phoneNumber = "915787878";
String name;
String address;
String age;
String sex;
String lastPrompt="Start";
String dateStamp;
String newqueue;
String mainTablePath;
String queuePath;

Table mainTable, queueTable;

File queue;

String getFormattedDate () {
  return year () +"_"+ (month () < 10? "0" + month () : month()) +"_"+( day () <10?"0"+ day():day());
}

Table checkAndLoadTable (String path) {
  File file = new File (path);

  if (file.exists ()) {
    return loadTable (path, "header");
  } else {
    Table table = new Table ();
    saveTable (table, path);
    return table;
  }
}
boolean isNewforsystem(String phonenumber) {
  phoneNumber="0909090909";
  if (phonenumber.equals(phoneNumber)) {
    return true;
  } else
  {
    return false;
  }
}

boolean isNewPatient (String phoneNumber) {
  int phoneIndex = mainTable.findRowIndex (phoneNumber, mainTable.getColumnIndex("Phone number"));
  if (phoneIndex == -1) {
    return true;
  } else {
    return false;
  }
  //comment
}

void setup() {
  dateStamp = getFormattedDate ();

  mainTablePath=dataPath ("") +"/Patients.csv";
  queuePath = dataPath ("") +"/Sequence_"+dateStamp+".csv";

  mainTable = checkAndLoadTable (mainTablePath);
  queueTable = checkAndLoadTable (queuePath);
}
void draw() {
  String input = showInputDialog ("");
  println (mainTable);
  println(mainTablePath);
  if (lastPrompt.equals("Start")) {
    showMessageDialog(null, "Welcom To "+nameofcenter+" \n 1. card = 50 birr\n2. detail");
    lastPrompt = "welcome";
  } else if (lastPrompt.equals("welcome")) {
    String choose=input;
    //if (choose.equals ("1") || choose.equals ("2")) {
    if (int(choose)==1) {
      if (isNewPatient(phoneNumber) == true) {
        showMessageDialog(null, "Enter Your  Name");
        lastPrompt = "name";
        if (lastPrompt.equals("name")) {
          name=input;
        }
      }

      // String transaction=showInputDialog("please enter your transaction code");
    }
    // new patient is true
    else {
      boolean hasToPay = hasToPayAnew (phoneNumber);

      if (hasToPay) {
        update_the_date(phoneNumber);
        queue_order(phoneNumber);

        showMessageDialog(null, "please pay 50 birr for service in telebirr.then send transaction code!");
        processTransactionNumber(input);

        showMessageDialog(null, "Payment Is Success.there are "+getPhoneNumberIndex(phoneNumber)+"  registrants before you");
      } else {
        update_the_date(phoneNumber);

        queue_order(phoneNumber);

        showMessageDialog(null, "There are "+getPhoneNumberIndex(phoneNumber)+"  registrants before you");
      }
    }
  } 
  
  //else if (int(choose)==2) {
  //  String  detail=showInputDialog("1. address\n2. service");

  //  if (int(detail)==1) {

  //    showMessageDialog(null, "our address // bishoftu, evangelical");
  //  } else if (int(detail)==2) {
  //    showMessageDialog(null, "Services \n1.        \n2.        \n3.          \n4.      ");
  //  } else {
  //    showMessageDialog(null, "error number");
  //  }   // for address and service input
  //} 
  
  else {
    showMessageDialog(null, "please enter correct number");
  }
}


void processTransactionNumber (String input) {
  String tranv="SEL";
  if (input.equals(tranv)) {
    saveTable (mainTable, "PhoneNumber");//put the patient on queue
  } else
  {
    showMessageDialog(null, "error tansaction code");
  }
}
int getPhoneNumberIndex(String input) {
  int order=queueTable.findRowIndex(input, 1);

  return order ;
}
void update_the_date(String phoneNumber) { 
  int phoneIndex = mainTable.findRowIndex (phoneNumber, 0);

  mainTable.getRow(phoneIndex).setString ("date", dateStamp);
  saveTable (mainTable, mainTablePath);
}
void queue_order(String phoneNumber) {
  TableRow newRow = queueTable.addRow ();
  newRow.setString ("Patient's Phone number", phoneNumber);
}

boolean hasToPayAnew (String phoneNumber) {
  int phoneIndex = mainTable.findRowIndex (phoneNumber, 0);
  String datepay=mainTable.getRow(phoneIndex).getString("date");
  int diff = diffBetween ( datepay, dateStamp );
  return diff > 5;
}
// void setup

void save_patient_info(Table table, String  phonenumber, String name, String address, String age, String sex, String date, String path ) {
  if (path.equals(mainTablePath) || path.equals(queuePath)) {
    //println ("Here 1", path);
    TableRow new_info = table.addRow();
    new_info.setString("Phone number", phonenumber);
    new_info.setString("Name", name);
    new_info.setString("Address", address);
    new_info.setString("Age", age);
    new_info.setString("Sex", sex);
    new_info.setString("date", date);
    println("file saved!");
    saveTable(table, path );
  } else {
    println (dateStamp);
    //println ("Here 2", path);
    //sequenceTable=new Table();E
    TableRow new_info=table.addRow();
    new_info.setString("Phone number", phonenumber);
    new_info.setString("Name", name);
    new_info.setString("Address", address);
    new_info.setString("Age", age);
    new_info.setString("Sex", sex);
    new_info.setString("date", date);
    saveTable(table, path );
  }
}

int diffBetween (String prev, String today) {
  prev = prev.replace ("_", "-");
  today = today.replace("_", "-");

  LocalDate prevDate = LocalDate.parse (prev);
  LocalDate currDate = LocalDate.parse (today);

  int counter = 0;

  while (!prevDate.isAfter (currDate)) {
    prevDate = prevDate.plusDays (1);

    counter ++;
  }

  counter --;

  return counter;
}
