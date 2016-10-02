trigger NotifyOnLevelChange on Contact (after update) {
    
  
    String levelMsg = null;
    
    for(Contact byl:Trigger.new) {
            Contact beforeUpdate = Trigger.oldMap.get(byl.id);
            if(byl.Loyalty_Points__c  != beforeUpdate.Loyalty_Points__c ) {
                
                if(beforeUpdate.Loyalty_Points__c < 1000 &&
                   byl.Loyalty_Points__c >= 1000 && 
                   byl.Loyalty_Points__c < 5000) 
                {
                    levelMsg = 'Forastero';
                }
                else if(beforeUpdate.Loyalty_Points__c < 5000 && 
                   byl.Loyalty_Points__c >= 5000 && 
                   byl.Loyalty_Points__c < 10000)
                {
                    levelMsg = 'Trinitario';
                }
                else if(beforeUpdate.Loyalty_Points__c < 10000 && 
                   byl.Loyalty_Points__c >= 10000)
                {
                    levelMsg = 'Criollo';
                }
                
                if(levelMsg != null) {
                   
                    //get admin profile. All users who will get notified of level
                    //changes should be part of this profile
                   List<Profile> nibsAdminProfile = [select id from Profile where name = 'NIBS Admin' limit 1];
                  for(user u : [select id from User where ProfileId = :nibsAdminProfile.get(0).id])
                  {  
                    String communityId = null;
					ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;
					String userToMention = u.id;
					String subjectId = userToMention;
                   
                    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
				    messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

				    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
                    textSegment.text = 'Hey there ';
                    messageInput.messageSegments.add(textSegment);
                  
                    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
				    mentionSegment.id = userToMention;
				    messageInput.messageSegments.add(mentionSegment);
                    
                    ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
                    textSegment2.text = '. ';
                   messageInput.messageSegments.add(textSegment2); 
                      
                    
                    ConnectApi.TextSegmentInput textSegment3 = new ConnectApi.TextSegmentInput();
                    textSegment3.text = byl.FirstName + ' '+byl.LastName+ ' just made '+levelMsg;
            	    messageInput.messageSegments.add(textSegment3);
                    
                   ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
				   input.body = messageInput;

				   ConnectApi.FeedItem feedItemRep = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.UserProfile, subjectId, input, null);
                  }    
                }
               
            }
        }
}