
Put this at line 563 in qb-inventory js file:


        } else if (itemData.name == "giftcard") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>For: </strong><span>$" +
                itemData.info.storename +
                "</span></p>"
                "<p><strong>Worth: </strong><span>$" +
                itemData.info.worth +
                "</span></p>"
            );


what this does is adjust what the inventory displays for the item data of that specific item, obviously u can just switch giftcard to whatever name u want the gift receipts to be.

Make sure you add a giftcard item

This resource does a job check to make sure the id you are using the card toward has the job. you can set the commision and whatever it doesnt take from the commission it sticks into the society funds of the business.You can set up so individual card locations can use marked money and you can set so marked money is worth less than its face value to launder toward a gift card.




