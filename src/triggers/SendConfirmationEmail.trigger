trigger SendConfirmationEmail on Session_Speaker__c (after insert) {
            for(Session_Speaker__c newItem : trigger.new) {
                // Retrieve session name and time + speaker name and email address
                Session_Speaker__c sessionSpeaker =
                    [SELECT Session__r.Name,
                            Session__r.Session_Date__c,
                            Speakers__r.First_Name__c,
                            Speakers__r.Last_Name__c,
                         Speakers__r.Email__c
                     FROM Session_Speaker__c WHERE Id=:newItem.Id];
                // Send confirmation email if we know the speaker's email address
                if (sessionSpeaker.Speakers__r.Email__c != null) {
                    String address = sessionSpeaker.Speakers__r.Email__c;
                    String subject = 'Speaker Confirmation';
                    String message = 'Dear ' + sessionSpeaker.Speakers__r.First_Name__c +
                        ',\nYour session "' + sessionSpeaker.Session__r.Name + '" on ' +
                        sessionSpeaker.Session__r.Session_Date__c + ' is confirmed.\n\n' +
                        'Thanks for speaking at the conference!';
                    EmailManager.sendMail(address, subject, message);
                }
} }