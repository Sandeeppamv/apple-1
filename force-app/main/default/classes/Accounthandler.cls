public class Accounthandler {
    public static void accmethod (list <account> acclist){
        // for loop to assign tier__c value based on annual revenue
        for(account a : acclist){
            if (a.AnnualRevenue > 100000){
                a.tier__c = 'platinum';
            }
            else if(a.annualrevenue >= 50000){
                a.tier__c = 'gold';
            }else{
                a.tier__c = 'diamond';
                // hahaha             
        }  
        }
    }
    
    public static void updateRelatedContacts (list <Account> acclist){
        //Assign records to set based on Id to remove duplicates
        set<Id> accid = new set <Id>();
        for(Account a :acclist){
            accid.add(a.Id);
            
        }
        //getting related contacts for each account
        list<Contact> conlist =[select id, name, accountid from Contact where Accountid IN :accid];
        map<id, account> accmap = new map<id, account>(acclist);
        for (contact c : conlist){
            if(accmap.containskey(c.accountid)){
                string tier = accmap.get(c.accountid).tier__c;
                if(tier == 'Platinum'){
                    c.Priority__c = 'High';
                }
                else if(tier == 'Gold'){
                    c.Priority__c = 'Medium';
                }else if(tier == 'Silver'){
                    c.Priority__c = 'Low';
                }
            }
        }
        if(!conlist.isempty()){
            update conlist;
        }
    }
    
    public static void restrictaccnamechange(list<account> acclist, map<id, account> oldmap){
        for(account a : acclist){
            account oldacc = oldmap.get(a.id);
            if(a.name != oldacc.name){
                a.name.adderror('account name should not change after creation');
            }
            
        }
    }
    
    // when ever account phone change update description with phone updated new value and old value  
    public static void phonefieldupdate(list<account> acclist, map<id, account> oldmap){
        for(account acc : acclist){
            account a = oldmap.get(acc.id);
            if(a.phone!= null && acc.phone != a.phone){
                acc.Description ='phone field updated new value: ' + acc.Phone + 'old value' + a.phone;
            }
            
        }
        
    } 
    
    // when account is created, contact should also be created
    public static void contactcreate (list<account> acclist){
        list<contact> conlist = new list<contact>();
        for(account acc : acclist){
            contact c = new contact();
            c.accountid = acc.Id;
            c.lastname = acc.name + 'contact';  
            conlist.add(c);
        }
        if(!conlist.isempty()){
            insert conlist;
        }
        
    }   
    
}