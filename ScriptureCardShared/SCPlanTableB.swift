import Foundation

enum SCPlanTableB {
    static let plans: [SCPlan] = [

        scplan("life-of-christ",
               "The Life of Christ",
               "Forty days through the Gospels",
               .love,
               "A walk through the story of Jesus in roughly the order it happened, from the opening lines of John to the last words on a hillside. Forty short readings drawn from Matthew, Mark, Luke and John, with a few older texts where the Gospels quote them. For anyone who knows pieces of the story and would like to see how they connect.",
               [
                scday("The Word",
                      ["John 1:1-3", "John 1:14"],
                      "John does not begin with a manger. He begins before anything at all, with a Word that was already there when the first light was made. Then, in one short sentence, that Word takes on flesh and moves in among ordinary people. Hold the two pictures side by side today: vast beginnings, and a life you could have walked past on a road."),

                scday("Light and darkness",
                      ["John 1:4-5", "John 12:46"],
                      "The claim here is modest in size and large in consequence. Light shines, and the darkness has not put it out. Not that darkness is absent, only that it has never won. John returns to the thought later, when Jesus speaks of coming so that no one need stay in the dark. A small lamp in a large room is still the thing everyone turns toward."),

                scday("Nothing impossible",
                      ["Luke 1:37", "Matthew 1:23"],
                      "Two announcements, both delivered to people whose plans were about to be rearranged. One says that nothing is impossible with God. The other gives a name, Emmanuel, which means God with us. Notice that the promise is presence before it is rescue. Whatever you are carrying into these forty days, the story opens with someone drawing near rather than solving from a distance."),

                scday("Mary's song",
                      ["Luke 1:46-49", "Luke 1:52-53"],
                      "A young woman with no standing sings about a God who notices low estate. Then the song widens: the powerful come down, the hungry are filled. It is a strange song for someone in her position, sung before anything visible has changed. Songs like this usually get written after the rescue. She sings it while still waiting, which may be the point."),

                scday("The night shift",
                      ["Luke 2:8-11", "Luke 2:12-14"],
                      "The birth is announced first to men working outdoors at night, near the bottom of the social order. The sign given them is deliberately unimpressive: a baby, wrapped up, lying in a feeding trough. Nothing about it would convince a skeptic. Luke seems interested in who hears the news first, and in how ordinary the evidence looks once you arrive."),

                scday("He shall save",
                      ["Matthew 1:21", "John 1:29"],
                      "The name arrives with a job description attached. Matthew says he will save his people from their sins, not from their circumstances, which is a narrower and harder promise than we might prefer. John points at him and calls him the Lamb, borrowing a word from the altar. Both writers are saying the trouble runs deeper than we usually admit."),

                scday("Travellers",
                      ["Matthew 2:1-2", "Matthew 2:10-11"],
                      "Foreigners reading the sky arrive with questions before anyone local has noticed. They travel a long way on thin evidence and end up kneeling in a house rather than a palace. The gifts are costly and slightly odd. What strikes me is the order: they rejoice first, then open the treasures. Giving seems to follow gladness here rather than produce it."),

                scday("The hidden years",
                      ["Luke 2:19", "Ecclesiastes 3:1"],
                      "After the shepherds leave, Luke gives one quiet line: Mary kept these things and pondered them. Then the story goes almost silent for years. Most of a life is like that, unrecorded, seasonal, slow. Ecclesiastes says there is a time for everything, which includes long stretches when nothing appears to be happening. If you are in such a stretch, you are in familiar company."),

                scday("He must increase",
                      ["John 3:30", "John 1:12-13"],
                      "John the Baptist has a crowd, and he watches it walk away toward someone else. His comment is a few plain words about decreasing. It does not read as resignation; he sounds relieved. Alongside it, John the writer describes people being given a place in a family they were not born into. Perhaps it is easier to become smaller once you are sure you belong."),

                scday("The wilderness",
                      ["Matthew 4:4", "Deuteronomy 8:3", "Hebrews 2:18"],
                      "Hungry after forty days, he answers the first suggestion with a line from Deuteronomy, spoken originally to people who had been fed in a desert. He does not argue. He quotes something older than the moment. Hebrews adds that, having been tested himself, he is able to help those who are tested. That sentence is offered as comfort rather than as instruction."),

                scday("The scroll",
                      ["Luke 4:18-19", "Isaiah 61:1"],
                      "He opens the scroll in his hometown synagogue and reads Isaiah aloud: good news to the poor, release for prisoners, sight for the blind. Then he sits down and says the words have arrived. Notice who is named in that list. Every category is someone with nothing to trade. Whatever else this work will be, it begins by turning toward people at the end of their resources."),

                scday("Follow me",
                      ["Mark 1:17", "Matthew 4:19-20"],
                      "Two words and a promise, spoken to working men in the middle of a shift. He does not ask what they believe or check their qualifications. He offers to make them into something rather than requiring them to arrive already made. The nets are left where they fall. Mark tells it quickly, as though the speed itself were part of what happened."),

                scday("Before dawn",
                      ["Mark 1:35", "Luke 5:16"],
                      "After a night of healing, with the whole town at the door, he gets up while it is still dark and goes out to a lonely place. Luke says this was a habit rather than a single incident. The busiest stretch of the story contains the most withdrawing. It is worth asking what he was protecting, and whether the thing you are too busy for is the same thing."),

                scday("Blessed are",
                      ["Matthew 5:3-6", "Matthew 5:7-10"],
                      "He begins the great sermon by congratulating the wrong people: the poor in spirit, the mourners, the meek, the hungry. Blessed here is closer to fortunate than to cheerful; it describes their position, not their mood. Read slowly, the list is unsettling. None of these conditions is one anyone would choose, and every one of them is called well off."),

                scday("Salt and light",
                      ["Matthew 5:13", "Matthew 5:14-16"],
                      "Two images that both assume smallness. Salt is never the meal, and a lamp is not the room. Neither works by drawing attention to itself, and both change what surrounds them. He adds the plain observation that no one lights a lamp and then hides it under a bowl. Little of this is about being impressive. Most of it is about being usable."),

                scday("Love your enemies",
                      ["Matthew 5:44-45", "Luke 6:35-36"],
                      "The hardest sentence in the sermon comes with a reason attached: the rain falls on everyone. The argument is not that enemies deserve it, but that this is simply how God behaves toward the world, indiscriminately generous. Luke's version ends on mercy. Notice that the command concerns action rather than affection. You are asked to do good, not to feel warm."),

                scday("When you pray",
                      ["Matthew 6:6", "Matthew 6:9-13"],
                      "First a door closes, then a prayer begins. He assumes prayer will be mostly unwatched, and the model he gives is startlingly short: a name, a kingdom, bread for one day, forgiveness in both directions, help staying out of trouble. Nothing elaborate. If you have ever suspected your praying was too plain to count, this is the pattern he handed over."),

                scday("Birds and lilies",
                      ["Matthew 6:25-26", "Matthew 6:28-30", "Matthew 6:33-34"],
                      "He does not argue anxiety down with logic. He points at birds and wildflowers, things his listeners could see from where they were sitting, and asks a question about worth. Then the closing line: sufficient to the day is its own trouble. Not a promise that tomorrow will be easy, only permission to leave it there. Today is the amount you have been given to carry."),

                scday("Ask, seek, knock",
                      ["Matthew 7:7-8", "Matthew 7:9-11"],
                      "Three verbs, each more persistent than the last, followed by a homely argument. If an ordinary father would not hand his hungry child a stone, what do you expect from a better one. The reasoning moves from the small and familiar upward. It does not promise that every request is granted, but it does rule out the idea that asking is unwelcome."),

                scday("Two houses",
                      ["Matthew 7:24-25", "Matthew 7:26-27"],
                      "The sermon ends with weather. Both builders meet the same storm, and the difference between them is underground, invisible until the rain comes. He does not say the wise man had a better house, only a better foundation. Hearing and doing are what separate them, which is a quiet warning to anyone who has enjoyed the sermon. Foundations get built in dry weather."),

                scday("For the sick",
                      ["Mark 2:17", "Luke 19:10"],
                      "Criticized for the company he keeps, he answers with a line about doctors and sick people, which is either a defense or a diagnosis depending on where you are standing. Luke states the mission plainly: to seek and to save what was lost. Both sentences assume that being in trouble is a qualification rather than a disqualification for his attention."),

                scday("Peace, be still",
                      ["Mark 4:39", "Mark 5:36"],
                      "He speaks to a storm the way you would speak to a dog, and it settles. Shortly after, to a father who has just heard the worst news, he says something smaller and harder: do not be afraid, only believe. The same voice does both. One calms water. The other asks a man to keep standing while nothing visible has changed yet."),

                scday("Moved with compassion",
                      ["Matthew 9:36-38", "Mark 6:31"],
                      "Seeing the crowds, he was moved with compassion, because they were harassed and scattered, like sheep without a shepherd. His response is to ask for more workers rather than fewer needs. And then, in Mark, he tells those same workers to come away and rest a while. Compassion and rest sit next to each other here without any apology being offered for either."),

                scday("The one who stopped",
                      ["Luke 10:33-34", "Luke 10:27"],
                      "A lawyer asks a definition question and receives a story. Two respectable men pass by, and then the outsider stops, and the details slow right down: oil, wine, bandages, his own animal, his own money. The story never answers who counts as a neighbour. It changes the question to what kind of person you are willing to be when you are the one who stops."),

                scday("One thing needed",
                      ["Luke 10:41-42", "Luke 18:1"],
                      "Martha is not doing anything wrong. She is doing too much, and she is angry about doing it alone. The gentle repetition of her name reads more like sympathy than rebuke. One thing is needed, he says, and never spells out a schedule. Luke records elsewhere that people ought always to pray and not lose heart. Attention seems to be the scarce resource."),

                scday("The lost one",
                      ["Luke 15:4-6", "Ezekiel 34:16"],
                      "Ninety-nine are safe and one is not, and the shepherd's arithmetic goes the wrong way. He leaves the sensible majority and goes out. When he finds the sheep he carries it home on his shoulders, which means the animal contributes nothing at all to its own return. Ezekiel had promised centuries earlier to seek what was lost. The story is old and the shoulders are new."),

                scday("The road home",
                      ["Luke 15:20-21", "Luke 15:22-24"],
                      "The son rehearses a speech and never finishes it. His father sees him a long way off, which suggests he had been watching the road, and then runs, which men of his age and standing did not do. The robe and the ring arrive before the apology is over. Whatever else this story teaches, the welcome was decided before the son got there."),

                scday("Two prayers",
                      ["Luke 18:13-14", "Matthew 23:11-12"],
                      "Two men pray in the same building. One lists his record, the other cannot lift his eyes and asks for mercy in seven words. The second man goes home right with God, which would have surprised the original hearers considerably. Matthew states the pattern elsewhere: whoever lifts himself is brought down. Less a rule than an observation about how weight settles."),

                scday("He wept",
                      ["John 11:35", "John 11:25-26"],
                      "He arrives late, on purpose, and then he cries. The shortest verse in the book records the fact without explaining it. He has just said he is the resurrection and the life, and minutes later he is standing at a grave with wet eyes. Believing something about what comes next did not spare him the grief of what had happened."),

                scday("Daily",
                      ["Luke 9:23", "Matthew 16:24-26"],
                      "The word daily is easy to miss and does most of the work in that sentence. This is not one grand renunciation but a small repeated one. Then the question about gaining the world and losing your soul, which sounds like a warning against greed but is really about exchange rates. What are you currently trading, and what did you get for it."),

                scday("Let them come",
                      ["Mark 10:14-16", "Matthew 18:3-4"],
                      "The disciples are managing his time sensibly, and he is displeased. He takes children in his arms and blesses them, then says the kingdom belongs to people like these. Children in that world had no status and no leverage. He is not praising innocence so much as pointing at people who receive without any means of repaying."),

                scday("Not to be served",
                      ["Mark 10:43-45", "Matthew 20:26-28"],
                      "Two brothers ask for the best seats, and the other ten are furious, mostly because they wanted them. He does not lecture about ambition. He inverts the ladder instead: whoever wants to be great serves. Then he puts himself into the sentence, saying he came not to be served but to serve. The pattern is offered by example rather than by rule."),

                scday("Two small coins",
                      ["Mark 12:43-44", "Matthew 22:37-40"],
                      "He sits opposite the treasury and watches people give, which is an uncomfortable detail. A widow drops in two coins worth almost nothing, and he says she gave more than all of them. The measure is not the amount but what remained afterwards. Set beside the two great commandments, love of God and neighbour, it suggests love is usually counted in what it costs."),

                scday("The towel",
                      ["John 13:14-15", "John 13:34-35"],
                      "On the last night he takes the towel and does the work of the lowest servant in the house, including for the man about to betray him. Then he gives what he calls a new commandment, and the newness lies in the standard: as I have loved you. He does not ask them to admire the gesture. He asks them to repeat it."),

                scday("Let not your heart",
                      ["John 14:1-3", "John 14:27"],
                      "He is comforting them on the worst night of their lives, and he knows it. Do not let your heart be troubled, he says, which implies some of it is a choice and some of it clearly is not. The peace he offers is defined by contrast, not as the world gives. Quieter than we expect, then, and far less dependent on circumstances."),

                scday("The vine",
                      ["John 15:4-5", "John 15:12-13"],
                      "The picture is of connection rather than effort. A branch does not strain to produce fruit; it stays attached and the fruit follows. Apart from me you can do nothing, he says, which reads as relief rather than threat once you stop bracing against it. Then love one another, with the measure set at laying down a life. Attached first, then the hard love."),

                scday("The garden",
                      ["Mark 14:36", "Luke 22:42", "Mark 14:38"],
                      "He asks to be let off. That request is in the record, preserved by people who might have been tempted to leave it out. Abba, Father, all things are possible, take this away. Then the turn: nevertheless, not what I will. Both halves are prayer. If honest reluctance disqualified a prayer, this one would not have survived."),

                scday("From the cross",
                      ["Luke 23:34", "Luke 23:43", "Isaiah 53:5"],
                      "Two sentences spoken from the cross: one asking forgiveness for the men holding the hammer, one promising a criminal that today he would be in paradise. Neither is addressed to the respectable. Isaiah, written long before, describes wounds that heal somebody else. The story does not explain the pain away. It insists the pain was going somewhere."),

                scday("He is not here",
                      ["Mark 16:6", "Luke 24:5-6", "Matthew 28:6"],
                      "The first word at the tomb is do not be afraid, which suggests the news was frightening before it was good. Why seek the living among the dead. Come and see the place where he lay. All three accounts stress the empty spot and the ordinary act of looking. Grief had made these women competent at graves. This grave had nothing for them to do."),

                scday("Go",
                      ["Matthew 28:18-20", "Mark 16:15", "Luke 24:32"],
                      "The story ends by not quite ending. He sends them out with a promise attached to the last clause: I am with you always. On the Emmaus road two of them had asked each other whether their hearts were not burning while he talked. That is where forty days leave you, walking somewhere ordinary, talking it over, accompanied."),
               ]),

        scplan("names-of-god",
               "Names of God",
               "Twelve names, twelve days",
               .praise,
               "Scripture rarely explains God in the abstract. It gives names, and most of them were first spoken in the middle of a crisis. Twelve days on twelve of those names and the situations that produced them. For readers who would like their praying to have more words in it than it currently does.",
               [
                scday("I AM",
                      ["Exodus 3:14", "Exodus 3:5"],
                      "Moses asks for a name and receives a sentence: I AM THAT I AM. It is not evasion, but it refuses to be pinned down the way a local deity could be. Just before it, he is told to take off his shoes because the ground is holy. A name and a boundary arrive together. Some things are only shown to people who have stopped walking straight through."),

                scday("Shepherd",
                      ["Psalms 23:1", "John 10:27-28"],
                      "Shepherd was not a compliment in the ancient world. It was work for younger sons and hired men, done outdoors, at night, with animals that wander. David chose the image anyway. Centuries later Jesus uses the same word and adds that his sheep know his voice. Both texts assume the sheep are not clever. All the competence in the picture belongs to the one holding the staff."),

                scday("The God who sees",
                      ["Genesis 16:13", "Psalms 139:7-8"],
                      "Hagar is a slave, pregnant, running through a desert away from a household that mistreated her, and she becomes the first person in the book to give God a name. She calls him the God who sees me. The psalm makes a similar point at cosmic scale, but her version came out of exhaustion. When you are invisible to everyone else, being seen is not a small thing."),

                scday("The Lord will provide",
                      ["Genesis 22:8", "Philippians 4:19"],
                      "Abraham says it on the way up the mountain, before he knows whether it is true, which is either faith or the only sentence a father could manage. God will provide himself a lamb. The provision arrives at the last possible moment, caught in a thicket. Paul repeats the theme in a thank-you letter to people who had just given away more than they could afford."),

                scday("Rock",
                      ["Deuteronomy 32:4", "1 Samuel 2:2", "2 Samuel 22:2-3"],
                      "Three writers, all in difficulty, reach for the same image. A rock is not warm and it does not comfort you. It holds. Hannah says it after years of humiliation, David after being hunted through the hills. What they are praising is not softness but reliability, something that does not shift when you lean your whole weight on it. Some seasons need exactly that quality."),

                scday("Strong tower",
                      ["Proverbs 18:10", "Psalms 46:1"],
                      "The picture is of a tower inside a walled town, the place people ran to when the walls failed. Notice the verb: the righteous run into it. Safety here is a destination you move toward rather than a feeling you generate. The psalm adds that God is a very present help, and present is the operative word, meaning found, available, near at hand."),

                scday("Slow to anger",
                      ["Exodus 34:6", "Psalms 103:8"],
                      "This is one of the few places where God describes himself, and the words chosen are merciful, gracious, slow to anger, abundant in goodness. Slow to anger is literally long of nose in the Hebrew, a picture of someone taking a long breath before answering. The psalm quotes the line back centuries later. Israel evidently kept returning to this sentence when they needed reminding."),

                scday("Holy",
                      ["Isaiah 6:3", "Revelation 1:8"],
                      "Holy means set apart and other, not simply very good. Isaiah hears it sung three times over, which in Hebrew is how you say that something is beyond comparison. John hears a related claim, Alpha and Omega, the first and last letters with everything between them included. Neither vision is cosy. Both writers end up on the floor. Awe is a legitimate response, and worth leaving room for."),

                scday("Father",
                      ["Psalms 103:13", "Romans 8:14-16"],
                      "Like a father pities his children, says the psalm, and pity there carries no condescension. It means tender concern. Paul goes further and says we cry Abba, the ordinary household word a child would use. For readers whose experience of fathers is complicated, this name is not simple. It may help that both texts describe how the father behaves rather than how the child feels."),

                scday("Prince of Peace",
                      ["Isaiah 9:6", "Isaiah 9:2"],
                      "Four titles arrive in a single line: Wonderful, Counsellor, the mighty God, the everlasting Father, the Prince of Peace. They are announced to a people described two verses earlier as walking in darkness. The order matters. The light is promised to those still in the dark, not to those who have already found their way out. Names like these are usually needed before they are understood."),

                scday("Redeemer",
                      ["Job 19:25", "Isaiah 43:1"],
                      "A redeemer was a relative with money who bought back what a family member had lost. Job uses the word from the ash heap, having lost nearly everything, and says he knows his redeemer lives. Isaiah's version is a name spoken aloud: I have called thee by thy name, thou art mine. Both take a legal transaction and make it entirely personal."),

                scday("The unchanging",
                      ["Revelation 22:13", "Hebrews 13:8", "Malachi 3:6"],
                      "The last name is really a claim about time. Alpha and Omega, the same yesterday and today and forever, I am the Lord, I change not. In a library full of people whose circumstances change constantly, this is the steady note underneath. Twelve names, and no one of them is the whole thing. Which of them did you most need this week."),
               ]),

        scplan("forgiveness",
               "Forgiveness",
               "Ten days on being forgiven and forgiving",
               .mercy,
               "Ten readings that move from being forgiven to forgiving other people, in that order, because the second is very hard without the first. Nothing here asks you to pretend an injury was small. For anyone carrying something they did, or something done to them, and would like to set it down.",
               [
                scday("An honest account",
                      ["Romans 3:23", "1 John 1:8-9"],
                      "Nothing here can begin until something is admitted. Paul flattens the field: all have sinned, bad news arranged as level ground. John adds that claiming otherwise is self-deception, and then, in the same breath, that confession is met with faithfulness. Confess in the older sense means to agree, to say the same thing about it. Naming it accurately is most of the work."),

                scday("East from west",
                      ["Psalms 103:12", "Micah 7:18"],
                      "The psalm chooses its geography carefully. North and south have poles, so a journey between them ends. East and west never meet, however far you travel. Micah asks a question rather than making a claim: who is a God like this, who delights in mercy. Delights is the surprising word. Not tolerates, not permits reluctantly. Something in this is gladly done."),

                scday("Scarlet",
                      ["Isaiah 1:18", "Psalms 51:10"],
                      "Come now and let us reason together, says a text that proceeds to do something quite unreasonable with dye. Scarlet was permanent. It was chosen precisely because it did not wash out. David's prayer, written after the worst chapter of his life, asks not for an excuse but for a clean heart, created rather than repaired. Both texts take the stain seriously. Neither treats it as final."),

                scday("No condemnation",
                      ["Romans 8:1", "Romans 5:8"],
                      "Two short verses doing the same work from opposite ends. One says there is now no condemnation. The other says the love arrived while we were still in the wrong, not after we had improved. The order matters. If the kindness had waited for the change, the change would be the price of it. As it stands, it is the response to it."),

                scday("Covered",
                      ["Proverbs 28:13", "Psalms 32:1"],
                      "Covering your own faults does not work, says the proverb, and anyone who has tried it knows the particular tiredness involved. The psalm uses the same verb the other way round: blessed is the one whose sin is covered, by someone else. The difference between hiding a thing and having it covered is who does the covering, and whether you still have to keep watch."),

                scday("Seventy times seven",
                      ["Matthew 18:21-22", "Mark 11:25"],
                      "Peter offers seven, which was generous by the standards of his day, and gets back a number designed to end the counting. Not a larger quota, a different category. Mark puts it more plainly: when you stand praying, forgive. Standing was the ordinary posture for prayer, so the instruction is simply about what to do with the thought that arrives while you are there."),

                scday("As you were forgiven",
                      ["Matthew 6:14-15", "Colossians 3:12-13"],
                      "This is the only line in the model prayer that comes with a comment attached, and the comment is not comfortable. Paul's version supplies a reason rather than a threat: forgive as Christ forgave you. The measure is not what the other person deserves but what you have already received. Held that way, the instruction stops being a debt and becomes a repetition."),

                scday("Putting it down",
                      ["Ephesians 4:31-32", "Proverbs 19:11"],
                      "Paul lists what to put away, and the list is specific: bitterness, wrath, clamour, evil speaking. Then, be kind. The proverb says it is a person's glory to pass over a transgression, which is not weakness but discretion, choosing what to let go by. Bitterness is heavy and it is also familiar, which is why putting it down usually has to happen more than once."),

                scday("Not repaying",
                      ["Romans 12:17-18", "Romans 12:19-21"],
                      "As much as lieth in you, live peaceably, a phrase that quietly admits some of it does not lie in you. Paul is not asking anyone to pretend. He asks that vengeance be handed off rather than carried out. Then the strange practical advice about feeding a hungry enemy. Overcoming evil with good is not a way of winning. It is what stops the exchange."),

                scday("The father running",
                      ["Luke 15:20-21", "Joel 2:13", "Nehemiah 9:17"],
                      "Two older writers describe a God slow to anger and ready to pardon, and then Jesus tells a story that puts it in a body. The father sees him a long way off and runs. The prepared speech gets interrupted halfway through. If you have been rehearsing something for years, this story suggests you may not get to finish it, and not for the reason you feared."),
               ]),

        scplan("grief-and-loss",
               "Grief and Loss",
               "Fourteen days that do not hurry",
               .hope,
               "Fourteen readings for someone who has lost a person. The first half stays with the lament psalms and with Job, because the Bible spends a great deal of time there and sees no need to apologize for it. Nothing here explains a death or promises a timeline. Read one a day, or read the same one for a week.",
               [
                scday("The cry",
                      ["Psalms 22:1"],
                      "My God, my God, why hast thou forsaken me. That sentence is in the book. Someone wrote it down, kept it, set it to music, and centuries later Jesus said it out loud from a cross. The verse does not answer it, and neither will this page. If that is where you are today, you are not outside the faith. You are quoting it."),

                scday("Naked I came",
                      ["Job 1:21", "Job 14:1"],
                      "Job says his famous line on the worst day of his life, and it is not serene. It is a man stating a fact while tearing his clothes. Man that is born of a woman is of few days and full of trouble. That verse has comforted people precisely because it softens nothing. Sometimes the first help is finding your situation described without any decoration on it."),

                scday("A time to weep",
                      ["Ecclesiastes 3:4", "Ecclesiastes 3:7"],
                      "A time to weep, a time to mourn, and, in the same list, a time to keep silence. Ecclesiastes does not rank these seasons or hurry them along. It says only that they exist and that they arrive. No schedule is attached. If people around you seem to think your time should be finished by now, this old text disagrees, and it is older than all of them."),

                scday("Out of the depths",
                      ["Jonah 2:2", "Psalms 61:2"],
                      "Jonah prays from inside the worst place he has ever been, and he does not describe it as anything other than what it is. The psalm asks to be led to a rock that is higher than I, which admits the writer cannot climb there without help. Both prayers are made from the bottom. Neither one waits for a better vantage point first."),

                scday("He wept",
                      ["John 11:35", "Isaiah 53:3"],
                      "He knew what he was about to do, and he cried anyway. That detail is not decoration. It may be the clearest thing in the chapter. Isaiah had used the phrase acquainted with grief, and acquainted means known personally, not observed from a distance. Whatever gets said later about hope is said by someone who stood at a grave and wept first."),

                scday("Cast down",
                      ["Psalms 42:5", "Psalms 42:1"],
                      "The psalmist talks to himself, which people in grief often do. Why art thou cast down, he asks his own soul, and instructs it to hope, and then a few lines later asks the same question again. The repetition is the honest part. He is not cured by his own advice. He keeps giving it, and he keeps thirsting, and both are allowed to stand."),

                scday("Near the broken",
                      ["Psalms 34:18", "Psalms 147:3"],
                      "The Lord is near to them that are of a broken heart. Near is a smaller claim than mended, and at this stage it may be the only one that helps. The second verse speaks of binding up wounds, which is what you do for an injury that is going to take a long time. Bandaging is not healing. It is what happens while healing does."),

                scday("The long night",
                      ["Psalms 30:5", "Psalms 63:1"],
                      "Weeping may endure for a night. The word endure is doing quiet work there. It does not say the night is short. Anyone who has lain awake knows that a night can last a very long time, and that morning is a claim you cannot verify from inside it. The other psalm is written from a dry land, early, thirsty. Both are night writing."),

                scday("Those who mourn",
                      ["Matthew 5:3-6", "Luke 6:21"],
                      "Blessed are they that mourn, for they shall be comforted. He does not say the mourning is good, and he does not explain the loss. He calls the mourner fortunate, which is an odd thing to say to someone at a funeral, and then attaches a future to it. Notice the tense. Shall be, not are. The comfort is promised rather than handed over."),

                scday("Passed along",
                      ["2 Corinthians 1:3-4", "Isaiah 66:13"],
                      "Paul writes of a God of all comfort who comforts us so that we can comfort others with what we ourselves received. That is the only use he suggests for it, and it belongs to later, not now. Isaiah's image is a mother comforting a child, which is neither an argument nor an explanation. It is a body holding another body until something settles."),

                scday("Not without hope",
                      ["1 Thessalonians 4:13-14", "John 11:25-26"],
                      "Paul does not tell them to stop grieving. He says not to grieve as those who have no hope, which leaves the grief entirely intact and changes only what surrounds it. Jesus makes his claim in the middle of a funeral, to a woman who had just told him he was late. Whatever weight these verses carry, they were first spoken to people who were crying."),

                scday("Sown in tears",
                      ["Psalms 126:5", "John 12:24"],
                      "They that sow in tears shall reap in joy. Sowing is a strange metaphor for grief because it insists on a long gap and hides everything underground. Jesus uses the same picture, of a seed that has to fall and stay there. Neither text says when. Both suggest that what is buried is not therefore finished, which is less than a cure and more than nothing."),

                scday("New every morning",
                      ["Lamentations 3:22", "Lamentations 3:23", "Lamentations 3:24"],
                      "These famous lines sit in the middle of a book of funeral poetry written over a ruined city, which is worth knowing before quoting them. His compassions fail not, they are new every morning. The writer is not describing a recovery. He is naming what he can still say while the ruins are in plain sight, and he says it one morning at a time."),

                scday("Every tear",
                      ["Revelation 21:3-4", "Revelation 21:5-7"],
                      "The last picture in the book is not a rescue out of the world but God moving into it, and the first thing described is a hand on a face. Every tear wiped away implies there were tears, that they were still there at the end, and that they are known one by one. Nothing here says the loss did not matter."),
               ]),

        scplan("starting-over",
               "Starting Over",
               "Fourteen days for a fresh start",
               .mercy,
               "Fourteen readings for anyone beginning again: after a failure, a move, a job that ended, a habit finally admitted. The Bible is largely a collection of second attempts, and the texts here are more interested in who does the rebuilding than in how quickly it goes. Expect small beginnings to be treated as normal rather than disappointing.",
               [
                scday("In the beginning",
                      ["Genesis 1:1", "Genesis 1:3"],
                      "The first sentence of the book is about something starting, and the first act is a word spoken into a formless dark. Nothing is required of the darkness beforehand. Whatever your own situation looks like this morning, the pattern here is that beginnings are made rather than found, and that the raw material was thoroughly unpromising to start with."),

                scday("A new thing",
                      ["Isaiah 43:19"],
                      "Behold, I will do a new thing; shall ye not know it. The question is odd until you notice what it assumes, that the new thing may already be under way before anyone recognizes it. It springs forth, which is plant language, slow and mostly hidden. A road through a wilderness is not visible until it has been walked a few times. Look for small evidence."),

                scday("A new heart",
                      ["Ezekiel 36:26", "Psalms 51:10"],
                      "Ezekiel promises the removal of a heart of stone. Stone is not wicked, it is simply unresponsive, which may be nearer the actual problem. David asks for a clean heart to be created, using the same verb that opens Genesis. Both texts assume this is not a thing a person manages by trying harder. It is asked for, and then it is given."),

                scday("New creature",
                      ["2 Corinthians 5:17", "Galatians 2:20"],
                      "Old things are passed away; behold, all things are become new. Paul wrote this to a congregation that was quarrelling and immature, so he cannot have meant that everything felt new. He is describing a status rather than a sensation. Galatians puts it as an exchange of lives. Read together, they suggest the newness is true some time before it becomes obvious."),

                scday("What is behind",
                      ["Philippians 3:13-14"],
                      "Paul does not claim to have arrived, which is unusual for a man writing from prison with his record. This one thing I do, he says, and then names two motions: letting go of what is behind and reaching toward what is ahead. Forgetting here is not amnesia. It is a refusal to let the old thing decide which direction you are facing."),

                scday("The lost years",
                      ["Joel 2:25", "Zechariah 9:12"],
                      "I will restore to you the years that the locust hath eaten. Locusts do not damage a field, they erase a season, and Joel names the loss as time rather than property. Zechariah calls people prisoners of hope, a strange phrase, as though hope were the thing holding them in place. Neither prophet pretends the lost years were not really lost."),

                scday("Seven falls",
                      ["Proverbs 24:16", "Micah 7:7"],
                      "A just man falleth seven times, and riseth up again. Seven means as often as it takes, and the proverb notably does not say the just man avoids falling. Rising is what defines him, not staying upright. Micah, sitting in a mess largely of his nation's making, says he will look and he will wait. Getting up is sometimes indistinguishable from waiting well."),

                scday("A fire on the beach",
                      ["John 21:15-16", "John 21:17"],
                      "Three denials by one fire, then three questions by another. Jesus does not review what happened. He asks the same thing three times, which hurts Peter, and then hands him work to do. Feed my sheep. Restoration here is not a conversation about the past. It is a job given to a man who was fairly sure he had disqualified himself."),

                scday("Small things",
                      ["Zechariah 4:10", "Zechariah 4:6"],
                      "Who hath despised the day of small things. The rebuilt temple was so modest that old men who remembered the first one wept at the sight of it. The prophet's answer is not that it will grow impressive, but that it will not be finished by might or by power. Small and slow is offered as the ordinary shape of a real beginning."),

                scday("Plans and steps",
                      ["Proverbs 16:9", "Proverbs 19:21"],
                      "A man's heart deviseth his way, but the Lord directeth his steps. The proverb does not discourage planning. It describes where planning ends and something else takes over. Many devices are in a man's heart, says the other line, and one counsel stands. If a plan of yours has recently collapsed, these verses treat that as ordinary rather than as a verdict on you."),

                scday("Asking for wisdom",
                      ["James 1:5-8", "Proverbs 3:5-6"],
                      "If any of you lack wisdom, let him ask, and it is given liberally and without upbraiding, which means without being made to feel foolish for needing it. That clause is easy to skip past. Proverbs supplies the harder half: lean not unto thine own understanding. Starting again usually involves admitting that your own reading of the situation was part of what went wrong."),

                scday("The old paths",
                      ["Jeremiah 6:16", "Isaiah 30:21"],
                      "Stand ye in the ways and see, and ask for the old paths, where is the good way. The instruction is to stop first, then look, then ask. Isaiah describes a voice behind you saying this is the way, which means the guidance comes while you are moving rather than before you set out. Neither text offers a map. Both assume walking."),

                scday("He who began",
                      ["Philippians 1:6", "Philippians 2:13"],
                      "Being confident of this very thing, that he which hath begun a good work will finish it. The confidence is placed in the one who started rather than in the one being worked on, which is a relief if you have started over before and lost your nerve. The second verse says God works in you both to will and to do. Even the wanting gets help."),

                scday("Behold, new",
                      ["Revelation 21:5-7", "Isaiah 43:1"],
                      "Behold, I make all things new. The tense is present and the scope is everything, a considerably larger claim than any of the fresh starts we manage on our own. Isaiah's line is smaller and closer: I have called thee by thy name, thou art mine. Fourteen days in, your own beginning may still be invisible. It is allowed to be quiet."),
               ]),

        scplan("waiting",
               "Waiting",
               "Ten days in the meantime",
               .endurance,
               "Ten readings for a season that has gone on longer than expected: a diagnosis, a job search, a prayer with no answer yet, a person who has not come back. These texts take waiting seriously as work rather than as a pause between the real parts of a life.",
               [
                scday("Be of good courage",
                      ["Psalms 27:14", "Isaiah 40:31"],
                      "Wait on the Lord, be of good courage. The pairing tells you something, that waiting takes nerve and is not a passive activity. Isaiah promises renewed strength and then lists it backwards: mount up, run, walk. Walking comes last because it is hardest. Almost anyone can manage a burst. Continuing on foot without fainting is the part that needs the renewing."),

                scday("Though it tarry",
                      ["Habakkuk 2:3", "Habakkuk 2:4"],
                      "The vision is for an appointed time; though it tarry, wait for it. Habakkuk had been complaining loudly, and the answer he receives amounts to not yet, with the date withheld. Tarry means to be slow in coming. The next line, the just shall live by his faith, describes what people do in the meantime, and it became one of the most quoted sentences in the book."),

                scday("Waiting and waiting",
                      ["Psalms 40:1", "Psalms 130:5"],
                      "I waited patiently for the Lord, and he inclined unto me. The Hebrew is closer to waiting and waiting, a doubled word, and nothing in it suggests calm. The other psalm waits for morning the way a night watchman does, counting the hours, wanting the shift to end. That is a fair picture of most waiting: awake, occupied, and not enjoying it much."),

                scday("The farmer",
                      ["James 5:7-8", "Ecclesiastes 3:1"],
                      "James points at a farmer waiting for a crop, a man who cannot make it rain and cannot make anything grow. His word for patient means long-tempered, the opposite of a short fuse. Ecclesiastes adds that everything has its season. There is real work in farming, but none of it is the growing. Knowing which part is yours saves an enormous amount of effort."),

                scday("Quietly",
                      ["Lamentations 3:25", "Lamentations 3:26"],
                      "It is good that a man should both hope and quietly wait. Quietly is not a mood requirement. The writer is grieving a destroyed city and the same book contains a great deal of shouting. Good here means suitable, the right thing for the circumstances, the way rest is good for a broken bone. Some seasons cannot be argued with, only sat through."),

                scday("A long promise",
                      ["Genesis 15:6", "Genesis 18:14"],
                      "Abraham believed, and it was counted to him for righteousness, and then he waited decades with nothing to show for it. Is any thing too hard for the Lord, comes the question, asked in a tent after Sarah laughed at what she overheard. Note that the laughter is recorded and not punished. Long waits produce strange reactions in ordinary people, and the story leaves them in."),

                scday("If we faint not",
                      ["Galatians 6:7-9", "2 Thessalonians 3:13"],
                      "In due season we shall reap, if we faint not. Due season means the appropriate time, which is not at all the same as soon. Paul's worry is not the harvest but the fainting, the quiet giving up that sets in when nothing seems to come of the sowing. Be not weary in well doing, he says again elsewhere. The instruction is aimed at the middle."),

                scday("With patience",
                      ["Hebrews 12:1-2", "Hebrews 12:3"],
                      "Let us run with patience the race that is set before us. Patience in older English meant endurance, staying under a load, not waiting pleasantly. The writer suggests laying aside the weight first, then looking away from yourself. And consider him, lest ye be wearied and faint in your minds. Weariness is treated as something that happens in the mind, which anyone in a long wait will recognize."),

                scday("A still small voice",
                      ["Psalms 46:10", "1 Kings 19:12", "Isaiah 30:15"],
                      "Be still, and know. Elijah, exhausted and hiding in a cave, gets wind and earthquake and fire, none of which held what he needed, and then a still small voice. In quietness and confidence shall be your strength, Isaiah tells a nation that badly wanted to do something dramatic instead. Stillness is not offered as a technique here. It is where the message finally arrived."),

                scday("Hope that holds",
                      ["Romans 5:3-5", "Romans 15:13"],
                      "Paul builds a chain: trouble works patience, patience experience, experience hope. It runs in the direction we would rather it did not, with the difficulty placed first. Experience there means proven character, the sort you only own after something has been tested. Hope maketh not ashamed, he adds, meaning it will not leave you looking foolish. That is the claim at the end of ten days."),
               ]),
    ]
}
