# LazyFlashCards

----
## What is it?


> When learning a new language, vocabulary is of paramount importance. One of the most efficient ways to learn vocabulary is through repetition and flash cards have been used for a long time as it is a very effective tool. LazyFlashCards is an app that automates the retrieval of the definition and pronunciation of Chinese, and English words so that the user does not have to type in these values themselves making the process of creating flash cards much faster. This is done through scraping the page source of an online dictionary for Chinese, and using the Pearson API for English.

---

## TODO

  1. Create the ViewController for Testing the users in NestedCardView branch
    * ~~Read about XIB files~~ 1/9/16
    * ~~Figure out how to create nested XIB files~~ 2/9/16
    * ~~Figure out the purpose of File's Owner and it's relationship with the XIB file~~ 2/9/16
    * ~~Create a queue data structure for the flash cards and make it work with Koloda, purpose of this is to add card that are swiped left (the card that the user doesn't know) to the end of the queue so that they will be retested~~ 7/9/16
    * Determine the weights to be used to determine whether the user will get the current card correct, maybe some exponential weighting where most recent results have most effect (LOW PRIORITY)
  2. ~~Figure a way out to determine the language in the phrase text field when adding the card, can't use NSLinguisticTagger as the phrase term is too short. Maybe determine by UTF8 encoding via dataUsingEncoding(NSUTF8StringEncoding) as English letters in UTF8 are only integers whereas in Chinese there are also letters~~ 4/9/16 
    * Ending up using a hacky way to solve it via CFStringTransform figure out a way that is extendable to other languages
  3. ~~Find a colour scheme for the app~~ 7/9/16
  4. ~~Create the delete buttons for the Deck and Card View Controllers in CreateButtons branch~~ 6/9/16
    * ~~Delete button for cards~~ 5/9/16
    * ~~Delete button for decks~~ 5/9/16
    * ~~Use callbacks instead of delegation read [here](https://medium.cobeisfresh.com/why-you-shouldn-t-use-delegates-in-swift-7ef808a7f16b#.wn71g2472) for the popup view controller that has the confirmation message to delete the deck~~ 6/9/16
  5. Create custom button and icons
    * ~~Deck~~ 10/9/16 
    * ~~Test~~ 10/9/16
    * ~~Delete~~ 10/9/16
    * Edit  
    * Search vocabulary
    * Add card after search 

  6. Create activity indication when retrieving information from the web
  7. ~~Refactor the code by using Factory pattern for coloring the UI elements so that it is less coupled with the ViewController code, and more easily customizable (HIGH PRIORITY)~~ 8/9/16
