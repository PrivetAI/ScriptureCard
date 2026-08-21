import Foundation

enum SCPlanTableC {
    static let plans: [SCPlan] = [

        scplan("lent",
               "Forty Days of Lent",
               "A slow walk toward Easter",
               .humility,
               "Forty days of self-examination, mercy and attention, ending in the week of the passion. The readings are short on purpose, so that the season is kept by returning rather than by covering ground. For anyone who wants to walk toward Easter honestly, without either gloom or hurry.",
               [
                scday("Ashes",
                      ["Genesis 3:9", "Psalms 90:12", "Ecclesiastes 1:2"],
                      "Many traditions begin this season with ash on the forehead, a mark that will be gone by evening. The question in Eden is not an accusation but a search: where are you. Ecclesiastes calls everything vapour, breath, the thing you cannot hold. Counting our days is not morbid arithmetic. It is the way a person learns which hours actually matter. What would you answer if the question came today?"),

                scday("Dust and clay",
                      ["Job 14:1", "Isaiah 64:8", "Psalms 103:13"],
                      "Job says a human life is short and full of trouble, which is not despair, only observation. Isaiah answers with an image of hands: clay does not shape itself. And the psalm sets a father beside a child, pity meaning tenderness rather than condescension. Held together, they describe a fragile thing that is nevertheless being handled with care. There is room in this season to admit both halves."),

                scday("A clean heart",
                      ["Psalms 51:10", "Psalms 51:17"],
                      "Create is a strong verb here, the same word used of the world being made. David does not ask for repair but for something new. And the sacrifice named is a broken spirit, which sounds bleak until you notice what it replaces: performance. Nothing is being demanded except honesty. If you have been carrying a fault quietly for weeks, this is the day to say it plainly and stop rehearsing it."),

                scday("Search me",
                      ["Psalms 139:23-24", "Psalms 32:1"],
                      "Asking to be searched is braver than it looks, since most of us prefer to conduct the inspection ourselves and grade generously. The psalmist invites a thorough look and then asks to be led. Notice the pairing with the other psalm, where the covered fault is called blessed, not exposed. Examination here is not a hunt for shame. It is closer to opening the windows of a room you have kept shut."),

                scday("The wilderness",
                      ["Deuteronomy 8:2", "Deuteronomy 8:3"],
                      "Forty years in the desert are described afterwards as a way of finding out what was in the heart. That is a generous reading of a hard stretch. The manna arrived daily and could not be hoarded, which taught dependence more effectively than any lecture. Lent borrows this shape deliberately. Emptiness is not the point; what surfaces in the emptiness is. What has this week shown you about yourself?"),

                scday("Not by bread",
                      ["Matthew 4:4", "Luke 12:15"],
                      "The reply in the wilderness is a quotation, not an argument, and it concerns proportion rather than denial. Bread is good. It is simply not the whole of a life. Luke puts it another way: a person is not the sum of possessions. Many keep this season by removing one ordinary comfort, not because comfort is wrong, but because the removal makes visible how much weight we had quietly placed on it."),

                scday("Rend the heart",
                      ["Joel 2:13", "Hosea 6:6"],
                      "Tearing your clothes was the old public sign of grief, and Joel asks for the inward version instead. Hosea says much the same: mercy is wanted more than ritual. Neither prophet is abolishing practice. They are asking that the practice mean something. A fast that leaves a person unchanged toward others has become an exercise. A small kindness done during it can be the truer sign."),

                scday("What is required",
                      ["Micah 6:8", "1 Samuel 15:22"],
                      "Micah reduces an enormous subject to three plain things, and none of them are complicated to understand, only difficult to keep. Justice, mercy, and a humble walk. Samuel makes the same point to a king who thought a large offering would cover a small disobedience. Obedience beats sacrifice because sacrifice can be arranged in advance, whereas attention has to be given in the moment. Which of the three is hardest this year?"),

                scday("In secret",
                      ["Matthew 6:6", "Matthew 6:19-21"],
                      "The instruction is to shut the door, which removes the audience and with it the temptation to perform. Whatever happens in that room is not reportable, and that is the value of it. The verses about treasure follow naturally: what you store somewhere is where your attention will settle. A season of private practice slowly relocates the heart without announcing itself. Nobody needs to know how your Lent is going."),

                scday("Two masters",
                      ["Matthew 6:24", "Ecclesiastes 5:10"],
                      "Divided service is presented not as a sin to be scolded but as a practical impossibility, like walking in two directions. Ecclesiastes adds the observation that the person who loves silver never reaches enough, since enough keeps moving. This is one of the quieter reasons for fasting. Going without something briefly reveals whether you hold it or it holds you. The answer is usually mixed, and that is useful to know."),

                scday("Quiet places",
                      ["Mark 1:35", "Luke 5:16", "Mark 6:31"],
                      "Three small notes, easy to read past. Rising before light. Withdrawing into the wilderness often. Telling tired friends to come apart and rest. In each case the crowd still needed something, and the withdrawal happened anyway. Whatever else these verses teach, they show that a full life and a quiet one are not opposites but a rhythm. Where in your week is there any silence that is not accidental?"),

                scday("A time to be silent",
                      ["Luke 10:41-42", "Ecclesiastes 3:7"],
                      "Martha is not criticised for working; she is described as careful and troubled about many things, and careful in older English meant full of care, weighed down by it. The one thing needful is not laziness but attention. Ecclesiastes allows both a time to speak and a time to keep silence, which means neither is superior by default. Today may simply be one of the silent ones."),

                scday("The still small voice",
                      ["1 Kings 19:12", "Psalms 46:10"],
                      "Elijah waits through wind, earthquake and fire, and none of them contain what he is listening for. What comes is a low whisper, sometimes rendered as the sound of thin silence. The psalm gives the corresponding instruction: be still. Stillness is not passivity here; it is the deliberate lowering of noise so that something quieter can register. Most of us have never tested how much noise is ours by choice."),

                scday("Thirst",
                      ["Psalms 63:1", "Psalms 42:1"],
                      "Two psalms reach for the same picture: a body needing water, a deer at a dry streambed. Thirst is not a feeling anyone manufactures. It arrives, and it is honest. Part of what a season like this does is uncover appetites we normally satisfy so quickly that we never notice them. Hunger of any kind, left unfilled for a while, becomes a fairly accurate map of what we actually want."),

                scday("Come and drink",
                      ["Isaiah 55:1", "John 4:13-14"],
                      "The invitation is shouted at people with no money, which rules out the idea that this is a reward for the well prepared. Come and buy without price. At a well in the heat of the day the same offer is made privately to one woman with a complicated life. Both scenes assume the thirst has already been felt. Nothing here requires you to arrive tidy."),

                scday("Honest words",
                      ["1 John 1:8-9", "Proverbs 28:13"],
                      "Saying we have no fault is described as self deception rather than modesty, and the cure offered is simply speech: name it. Proverbs adds that what is covered does not prosper, which most people learn the slow way. Confession in these verses is not humiliation. It is the end of maintenance, the moment you stop spending energy on a story that was never quite true."),

                scday("As far as the east",
                      ["Psalms 103:12", "Isaiah 1:18"],
                      "East and west never meet; the measurement was chosen for that reason. Isaiah offers a courtroom scene that turns unexpectedly into an invitation to reason together, scarlet becoming white as snow. Whatever a reader believes about the mechanics of this, the tone is worth noticing. It is not grudging. Many people find forgiveness easier to affirm in general than to accept in their own case."),

                scday("Delighting in mercy",
                      ["Micah 7:18", "Psalms 86:5"],
                      "Micah asks who else is like this, a God who does not keep anger because he delights in mercy. Delight is a strong word to attach to forgiveness; it suggests something more than reluctant permission. The psalm says the same in plainer terms, ready to forgive and plenteous in mercy. If you find that hard to believe about yourself, notice how readily you believe it about someone you love."),

                scday("The back of the room",
                      ["Luke 18:13-14", "James 4:10"],
                      "Two men pray. One gives an accurate account of his virtues; the other stands at a distance and asks for mercy, and it is the second who goes home lighter. James condenses this into a single line about being lifted. Humility in these verses is not self dislike, which is only pride facing the other way. It is standing at a realistic height and finding that the ground holds."),

                scday("Before the fall",
                      ["Proverbs 16:18", "Proverbs 11:2", "Proverbs 29:23"],
                      "Three short proverbs on one subject, which is how the book signals that it matters. Pride goes before destruction. Shame follows pride. A person brought low is held up by honour. The observation is practical rather than moral: inflated self assessment makes a person clumsy, unable to take advice, surprised by ordinary difficulty. Humility is described here as a kind of accuracy, and accuracy tends to keep its footing."),

                scday("As a child",
                      ["Matthew 18:3-4", "Mark 10:14-16"],
                      "Children in that world had no standing to trade on, which is part of what makes the comparison sharp. When the disciples try to clear them away, they are stopped and the children are gathered up. Becoming as a little child is not about innocence or naivety. It points to someone who receives without calculating what it will cost them in status. Most adults have to relearn that slowly."),

                scday("Servant of all",
                      ["Mark 10:43-45", "Philippians 2:3-4"],
                      "The disciples had been arguing about rank, and the answer inverts the question rather than settling it. Whoever wants to be great becomes a servant. Paul repeats the idea as a habit of attention: look also to the concerns of others. Neither passage asks anyone to think badly of themselves. It asks for less thinking about themselves, which is a different and more restful thing entirely."),

                scday("Emptied",
                      ["Philippians 2:5-8", "Philippians 2:9-11"],
                      "This passage is probably an early hymn, and it moves downward before it moves up: equality not clutched at, the form of a servant, obedience as far as death. The lifting that follows is not something grabbed. Whatever else the season involves, this is the shape it keeps returning to. Descent first. It is worth reading the two halves together so that the humility does not sound like defeat."),

                scday("Loose the bonds",
                      ["Isaiah 61:1", "Matthew 25:35-36"],
                      "The prophet describes a commission with recipients named plainly: the poor, the broken hearted, the captives. Matthew lists similar people from the other direction, as the ones already visited or fed or clothed. Many traditions attach almsgiving to fasting for exactly this reason. What is set aside on one side of the ledger is meant to appear on the other. A fast that saves money and keeps it has half a shape."),

                scday("The least",
                      ["Matthew 25:40", "Proverbs 25:21"],
                      "Whatever was done to the least is counted as done directly, without intermediary. It is a startling claim, and it makes small unnoticed acts the ones that carry weight. Proverbs goes further and puts bread in front of an enemy. Neither verse asks for a feeling first. Both describe an action, which is convenient, since actions can be taken on days when the corresponding warmth is missing."),

                scday("Forgive",
                      ["Matthew 6:14-15", "Matthew 18:21-22"],
                      "Peter offers seven, which was already generous, and receives a number meant to end the counting rather than raise the limit. The line in the Sermon on the Mount is uncomfortable and rarely softened well. Perhaps the plainest reading is that a closed hand cannot receive. Forgiveness in these verses is not the same as pretending harm did not happen. It is the decision not to keep the ledger open."),

                scday("Enemies",
                      ["Matthew 5:44-45", "Romans 12:17-18"],
                      "The instruction is not to feel affection but to pray, which is a specific and manageable act. Rain falls on the just and unjust alike, and the reasoning follows from that. Paul is realistic in a way people often miss: as much as lies in you, if it is possible. He does not promise the other party will cooperate. Only your own half of the peace is being asked for."),

                scday("Judge not",
                      ["Matthew 7:1-2", "Luke 6:37-38"],
                      "The warning is about the measure, not about having opinions. Whatever standard you use gets handed back to you, which is a quiet argument for generosity. Luke adds the image of grain pressed down and running over, more than the container was designed for. Self examination and judging others turn out to be opposite motions. Most of us find one much easier, and it is not usually the first."),

                scday("Take up the cross",
                      ["Luke 9:23", "Matthew 16:24-26"],
                      "Daily is the word that keeps this from being dramatic. A cross taken up once a year would be an event; taken up daily it becomes ordinary, closer to the small refusals that shape a person over time. The paradox that follows is stated twice, about losing and finding. It resists explanation and probably should. Some sentences are meant to be carried around rather than solved."),

                scday("The grain of wheat",
                      ["Mark 8:36-37", "John 12:24"],
                      "A seed kept safe stays exactly what it is, which sounds like preservation and is actually a kind of stalling. The question about gaining the world and losing the soul is asked in the same spirit. Neither verse condemns wanting a good life. They question the arithmetic behind a life spent entirely on protection. What are you holding intact that might be more useful spent?"),

                scday("Pruned",
                      ["John 15:4-5", "Hebrews 12:11"],
                      "Pruning is the gardener cutting off wood that is alive but unproductive, which is why it feels unreasonable at the time. Hebrews is honest about this: no discipline seems pleasant while it lasts. The vine image adds that fruit was never the achievement of the branch anyway. Abide is a restful verb. It asks for continued presence rather than effort, which may be the harder request."),

                scday("The long road back",
                      ["Luke 15:20-21", "Luke 15:22-24"],
                      "The son has a speech prepared and does not get to finish it, because the father is already running, which no dignified man in that culture would do. The robe and ring are restorations of standing, not rewards for the speech. Whatever brought a person to the road matters less in this story than the direction they are finally walking. Rehearsed apologies are often interrupted by welcome."),

                scday("The one that wandered",
                      ["Luke 15:4-6", "Luke 19:10"],
                      "Ninety nine is a good number by most accounting, and the shepherd still leaves to go after one. Notice the ending: it is carried home on the shoulders, not driven back. Luke summarises the whole pattern later in a single sentence about seeking what was lost. If you have been assuming the search was called off some time ago, this is the day to reconsider that."),

                scday("A heart of flesh",
                      ["Ezekiel 36:26", "2 Corinthians 5:17"],
                      "Ezekiel promises a replacement rather than an improvement: stone taken out, flesh put in. Stone here means unresponsive, not strong. Paul describes the same thing as old things passing and something new arriving. Both are claims about change that a person does not manufacture in themselves. Lent, kept honestly, is less about self improvement than about clearing enough space to notice what has already begun."),

                scday("The narrow gate",
                      ["Matthew 7:13-14", "Jeremiah 6:16"],
                      "Narrow does not mean mean spirited; it means specific, the way any real path is specific while open country is not. Jeremiah asks travellers to stand at the crossroads and ask for the old paths, and then to walk in them. The asking is only half of it. Many people enjoy standing at the crossroads indefinitely. Deciding is uncomfortable, and it is also the only way to arrive anywhere."),

                scday("Into the city",
                      ["Psalms 118:24", "Psalms 118:6"],
                      "This is the psalm the crowds were quoting as they lined the road with branches. Reading it now, with the week ahead already known, changes the tone. The day the Lord has made turns out to include the days that follow, which are not celebratory. The line about not fearing what people can do is not bravado; it is spoken by someone who has counted the risk and gone forward."),

                scday("The basin",
                      ["John 13:14-15", "John 13:34-35"],
                      "Washing feet was work for the lowest servant in the house, and the discomfort in the room comes from watching the wrong person do it. The new commandment is given immediately afterwards, so the demonstration is the definition. Love here is not first a feeling but a task performed with a towel. Small services, done without comment, still carry more meaning than most of what we say."),

                scday("Watch and pray",
                      ["Mark 14:36", "Mark 14:38"],
                      "The prayer in the garden asks twice: remove this, and yet not what I will. Both halves are prayed by the same person in the same breath, which is permission for anyone whose prayers contradict themselves. The disciples fall asleep, and the comment about willing spirit and weak flesh is offered without contempt. Tiredness is not treated as betrayal here, only as the truth about bodies."),

                scday("Friday",
                      ["Isaiah 53:3", "Isaiah 53:5", "Luke 23:34"],
                      "Isaiah writes of one despised and acquainted with grief, a phrase that means familiar with it rather than merely aware. Luke records a sentence spoken from the cross asking forgiveness for people who did not understand what they were doing. Traditions differ widely on how to explain this day. Almost all of them agree on how to keep it, which is quietly, and without hurrying to Sunday."),

                scday("The waiting day",
                      ["Isaiah 53:6", "Luke 23:43", "Psalms 130:5"],
                      "Saturday in the old accounts is empty. Nothing is reported except a sealed tomb and people keeping the sabbath because that is what the day required. The line about all of us turning to our own way sits here without resolution. So does the promise made to a dying man beside him. Waiting is the whole practice today. The psalm says it best: I wait, and in his word I hope."),
               ]),

        scplan("advent",
               "Advent",
               "Twenty-five days of waiting",
               .hope,
               "The weeks before Christmas, read in the order the story came: the prophets first, then the annunciation, the shepherds and the star, ending on Christmas Day. Each day is short enough to keep during a busy month. For anyone who would rather arrive at the twenty-fifth than be ambushed by it.",
               [
                scday("Waiting begins",
                      ["Psalms 130:5", "Habakkuk 2:3"],
                      "Advent starts in the dark, several weeks before anything arrives, and the first discipline of it is waiting without knowing how long. Habakkuk is told the vision is for an appointed time and will not lie, even if it seems slow. The psalm puts waiting and hoping in the same sentence, as though they were one act. Most of us wait badly. This season offers practice at doing it well."),

                scday("A light in the darkness",
                      ["Isaiah 9:2", "John 12:46"],
                      "Isaiah addresses people walking in darkness, not sitting in it, which suggests they were still going about their business. That is usually how it is. The light in the prophecy is described as already seen, past tense, before anything visible has changed. John repeats the image centuries later in the first person. Whatever your December looks like, notice that the promise is made to people mid journey."),

                scday("Unto us a child",
                      ["Isaiah 9:6", "Psalms 146:5"],
                      "The titles pile up in one verse: counselor, mighty, everlasting, prince of peace. Then the sentence lands on a child. Whatever else Isaiah is doing, he is refusing to let power and vulnerability stay in separate categories. The psalm names as happy the person whose help and hope are placed outside themselves. Both verses ask a reader to expect something large in a small and unlikely form."),

                scday("Comfort",
                      ["Isaiah 40:11", "Isaiah 40:28"],
                      "The chapter moves between two scales without apology. A shepherd carrying lambs in his arms, gently leading the ones with young. And a creator who does not grow faint or weary, whose understanding cannot be searched out. Held together they say something a single image could not. Tenderness is not a substitute for strength here; the same one is credited with both."),

                scday("Strength for the weary",
                      ["Isaiah 40:29", "Isaiah 40:31"],
                      "The famous verse is usually quoted for the eagles and the running, but the order matters: mount up, run, walk. Walking without fainting comes last, which suggests it is the hardest and most ordinary of the three. The preceding line is addressed to those who have no might at all. Renewal here is promised to the depleted, not to the already capable. Waiting is the condition attached."),

                scday("Fear not",
                      ["Isaiah 41:10", "Isaiah 41:13"],
                      "Do not be afraid appears constantly in these chapters, and it is never argued for. It is simply repeated alongside a reason: I am with you. The second verse adds a physical detail, a hand held. Fear is not being dismissed as unreasonable. It is being answered with presence rather than explanation, which is what most frightened people actually need at the time."),

                scday("Called by name",
                      ["Isaiah 43:1", "Isaiah 49:16"],
                      "Redeemed, called by name, and told you are mine. Names matter in these texts because they mark the difference between a category and a person. The second image is stranger and more physical: engraved on the palms of the hands, the way someone writes a reminder they cannot afford to lose. Being known individually is one of the harder things to believe about oneself in a crowded month."),

                scday("A new thing",
                      ["Isaiah 43:19", "Isaiah 55:11"],
                      "Behold, I do a new thing, and then a question: will you not perceive it. The assumption is that the new thing may already be underway and simply unnoticed. Rivers in the desert are not subtle, yet the prophet expects them to be missed. The later verse promises that a word sent out accomplishes what it was sent for. Slowness and failure are not the same thing."),

                scday("Come without money",
                      ["Isaiah 55:1", "Isaiah 55:8-9"],
                      "Everyone who thirsts is invited, and the price is explicitly nothing. In a season heavy with buying, that is worth sitting with for a minute. The verses about higher thoughts and higher ways follow soon after, and they are usually quoted to explain disappointment. In context they are about mercy being more generous than expected. The gap runs in the direction people rarely assume."),

                scday("The one despised",
                      ["Isaiah 53:3", "Isaiah 53:5"],
                      "It is unusual to read these verses in Advent, though the child and the servant are the same figure in the tradition. Nothing about the description is triumphant: despised, rejected, familiar with grief. Whatever you believe about how the wounding works, notice that the hope offered here is not a hope that avoids suffering. It goes through it. That is a different and sturdier kind of promise."),

                scday("Good news to the poor",
                      ["Isaiah 61:1", "Luke 4:18-19"],
                      "In Luke the prophecy is read aloud in a home synagogue, and then the scroll is handed back and the reader sits down. The list is concrete: poor, broken hearted, captives, blind, bruised. No part of it is metaphorical only. If Advent is about expecting an arrival, these verses describe what the arrival is for. Which item on the list would you place yourself under this year?"),

                scday("The sun of righteousness",
                      ["Malachi 4:2", "Malachi 3:6"],
                      "Malachi closes with a sunrise and calves let out of a stall, which is an image of relief and unreasonable energy. Just before it stands a plainer sentence: I do not change. Four hundred years of quiet follow this book in most reckonings. The last words left standing were about constancy and a morning coming. That is not a bad place to wait."),

                scday("Wait quietly",
                      ["Micah 7:7", "Lamentations 3:25", "Lamentations 3:26"],
                      "Micah says he will watch and wait, which is an active posture, not resignation. Lamentations, a book of grief, contains the line about the goodness of waiting quietly. Quietly is the word that stings; most waiting is noisy inside. These verses do not promise a short wait. They suggest that how a person waits shapes them as much as what eventually arrives does."),

                scday("Not by might",
                      ["Zechariah 4:6", "Zechariah 4:10"],
                      "The temple rebuilding had stalled and looked pitiful next to memories of the old one. The answer given is not a strategy but a redirection: not by might, nor by power. Then a question about despising the day of small things, which most people do without noticing. Beginnings look unimpressive by nature. Advent is largely an argument for taking small unfinished things seriously."),

                scday("Joy over you",
                      ["Zephaniah 3:17", "Zechariah 9:12"],
                      "Zephaniah describes something startling: quiet in his love, and joy expressed in singing. It is an image of delight rather than tolerance. Zechariah calls the waiting ones prisoners of hope, which is a strange and good phrase, suggesting hope can hold a person as firmly as despair does. Both verses assume the reader is somewhere difficult and speak to them there."),

                scday("Nothing too hard",
                      ["Luke 1:37", "Genesis 18:14"],
                      "The line spoken to Mary is a near quotation of the question asked of Sarah generations earlier: is anything too hard. Both women laugh or wonder, and neither is scolded for it. The pattern is old by the time Luke uses it. Whatever else these announcements do, they interrupt the settled sense of what can still happen to a particular person at a particular age."),

                scday("Mary's song",
                      ["Luke 1:46-49", "Luke 1:52-53"],
                      "The song is not sentimental. It moves quickly from personal gratitude to the mighty being pulled from their seats and the hungry filled. Mary sings it while pregnant and unmarried in an occupied province, which gives the lines their edge. Whatever the season becomes commercially, this is the first Christmas music on record, and it is about reversal more than comfort."),

                scday("God with us",
                      ["Matthew 1:21", "Matthew 1:23"],
                      "Two names are given in a few verses. One describes what the child will do; the other, quoted from Isaiah, describes where God will be, which is here. Matthew is writing to people who knew the older text well and would have felt the weight of the borrowing. The claim is not that trouble ends. It is that the address has changed."),

                scday("Shepherds",
                      ["Luke 2:8-11", "Luke 2:12-14"],
                      "The announcement goes to men working a night shift on a hillside, not to anyone who had been waiting in a temple. The sign they are given is deliberately unremarkable: a baby wrapped in cloth, lying in a feeding trough. You would have to look to find it. Much of this story turns on who is told first, and it is usually not the people you would expect."),

                scday("Kept in the heart",
                      ["Luke 2:19", "Psalms 119:11"],
                      "Mary kept these things and pondered them, which the older word renders as turning them over repeatedly. She does not explain them or announce them. The psalm uses a similar image of words hidden in the heart, stored rather than displayed. In a month of noise there is something to be said for holding a few things privately until they have had time to mean something."),

                scday("The star",
                      ["Matthew 2:1-2", "Matthew 2:10-11"],
                      "Foreigners with the wrong religion read the sky, travel a long way, and arrive before the local experts have got up. The gifts are odd and famous. What is easy to miss is how long the journey took and how little information they had, which is a fair description of most people and their faith. They followed one light and asked directions when they lost it."),

                scday("The word made flesh",
                      ["John 1:1-3", "John 1:14"],
                      "John begins where Genesis begins, with the beginning, and then does something no one expected: the word pitches a tent among us. Dwelt in the older translation carries the sense of camping, temporary and close. There is no stable, no shepherds, no star in this account. It is the same event described from a great height, and it loses none of its physicality."),

                scday("The light shines",
                      ["John 1:4-5", "John 8:12"],
                      "The darkness did not comprehend it, and the older word means both understood and overcame, which is a useful ambiguity. Light in these verses is not described as winning a battle. It simply continues, and darkness has no method for putting it out. On one of the shortest days of the year that is a modest and durable claim to hold on to."),

                scday("The last evening",
                      ["Luke 12:32", "Romans 15:13"],
                      "Fear not, little flock, is addressed to a group small enough to feel their smallness. Paul closes his longest letter with a wish rather than an argument: joy and peace in believing, and hope abounding. Tonight is the end of the waiting, and it is worth noticing before the day itself arrives. Something is different about the last hour of any long wait."),

                scday("Christmas Day",
                      ["John 3:16-17", "John 1:12-13", "1 John 4:9-10"],
                      "The most quoted verse in the Bible is a sentence about giving. The one after it is less known and softer: not sent to condemn the world. The letter of John says the love did not begin with us, which removes the pressure to feel enough of it today. However the day goes, loud or quiet or a little sad, the claim being celebrated is that someone came here."),
               ]),

        scplan("holy-week",
               "Holy Week",
               "Palm Sunday to Easter morning",
               .mercy,
               "Eight days, one for each day of the last week, from the road into the city to the empty tomb. The readings stay close to what each day holds and do not rush ahead. For anyone who wants to keep the week slowly rather than arrive at Sunday without having been through it.",
               [
                scday("The road into the city",
                      ["Psalms 118:24", "Psalms 118:6"],
                      "The crowd on the road was quoting this psalm, waving what they had, expecting one kind of king. Within the week most of them will have gone quiet. Reading their song now, knowing the ending, gives the words a different weight. This is the day the Lord has made still holds when the day turns out to be difficult. That is the harder version of the line."),

                scday("In the temple",
                      ["Matthew 21:22", "Hosea 6:6"],
                      "Monday, in the traditional reckoning, is the day of overturned tables and a barren fig tree, both of them about the difference between appearance and fruit. Hosea had said it plainly centuries earlier: mercy rather than sacrifice. The verse about asking in prayer belongs to the same conversation, spoken to people who had just watched the machinery of religion interrupted. Systems can run smoothly and still be empty."),

                scday("The great commandment",
                      ["Matthew 22:37-40", "Matthew 23:11-12"],
                      "Tuesday is a day of questions, most of them designed as traps. The answer given reduces everything to two commands hung together, love of God and love of neighbour, with nothing else allowed to outrank them. Then a warning about titles and seats, and the reversal that runs through the whole week. The greatest is the servant. By Thursday there will be a demonstration."),

                scday("Two small coins",
                      ["Mark 12:43-44", "Isaiah 53:3"],
                      "Wednesday is nearly silent in the accounts. What survives from these days is a small scene: a widow putting in two coins, and the observation that she gave more than everyone, having given from her need rather than her surplus. The servant in Isaiah is described in the same key, unregarded, easy to look past. The week keeps drawing attention to people the crowd walks by."),

                scday("The upper room",
                      ["John 13:14-15", "John 13:34-35", "Mark 14:36"],
                      "Thursday holds a meal, a basin, and a garden. The washing of feet is done by the wrong person, deliberately, and then named as an example. Later, among the olive trees, comes a prayer that asks for the cup to pass and then hands the decision over. Both scenes are about a will being laid down. Many traditions keep this night with a stripped table and no ending."),

                scday("Friday",
                      ["Isaiah 53:5", "Luke 23:34", "Luke 23:43"],
                      "The two sentences Luke records from the cross are both directed outward: forgiveness asked for the people carrying it out, and a promise made to a criminal beside him. The line in Isaiah about wounds and healing has been read in many ways across the traditions. What none of them dispute is that this day is described as a death, unhurried and public. It is not read quickly."),

                scday("Saturday",
                      ["Psalms 22:1", "Psalms 130:5", "Job 19:25"],
                      "Nothing happens on Saturday in the gospels. The body is in the tomb, the sabbath is kept, and the followers are somewhere out of sight. The psalm of abandonment sits here without an answer yet. So does the stubborn line from Job about a redeemer living. Many people know this day better than the other two. It is the one where you wait without evidence."),

                scday("Easter",
                      ["Luke 24:5-6", "Mark 16:6", "Matthew 28:6"],
                      "Why seek the living among the dead is a question, not an announcement, and the first witnesses are given work to do rather than an explanation. Each gospel tells it slightly differently, which has always struck readers as a sign of real testimony rather than a problem. Come and see the place, one of them says. The invitation is to look, and then to go and tell."),
               ]),

        scplan("armour-of-god",
               "The Armour of God",
               "Seven days in Ephesians six",
               .endurance,
               "A short passage taken slowly. Paul borrows the kit of a Roman soldier, a man he could see from where he was chained, and turns each piece into something a person can put on inwardly. For anyone in a long stretch where the task is simply to keep standing.",
               [
                scday("Be strong",
                      ["Ephesians 6:10-12", "Psalms 28:7", "2 Corinthians 12:9-10"],
                      "Paul writes this while chained to a soldier, which is probably where the images come from. Notice that the first instruction is not to be strong in yourself but in something borrowed. The psalm calls the same thing a shield already held. And the letter to Corinth turns the whole idea over: strength made perfect in weakness. Endurance in these letters is rarely described as toughness."),

                scday("Truth at the waist",
                      ["Ephesians 6:13-15", "John 8:31-32", "Psalms 86:11"],
                      "The belt was the unglamorous piece, the one that gathered a long tunic so a man could move. Truth is placed there, at the waist, holding everything else in position. John connects truth with freedom rather than with argument. The psalm asks for an undivided heart, which is the same thing from the inside. Most of what tangles a person is some small untruth being carried."),

                scday("The breastplate",
                      ["Romans 5:1-2", "Philippians 3:13-14", "Proverbs 4:23"],
                      "Armour over the chest protects the parts that cannot be repaired. Paul names it righteousness, and elsewhere describes that as peace already made rather than a record being defended. The letter to Philippi adds forgetting what is behind, which is not amnesia but a refusal to keep reopening the case. Proverbs says to guard the heart because everything else flows from it. The three fit together neatly."),

                scday("Ready feet",
                      ["Romans 12:17-18", "Colossians 3:14-15", "Matthew 5:7-10"],
                      "Boots are for standing, and yet the gospel of peace is what a soldier is shod with, which is a strange combination on purpose. Paul asks for peace as far as it depends on you, an honest limit. Colossians makes peace an umpire in the heart, the thing that settles disputes. And the beatitudes place peacemakers, not peacekeepers, among the blessed. Making peace involves walking somewhere."),

                scday("The shield",
                      ["Ephesians 6:16-18", "Genesis 15:1", "Psalms 91:4"],
                      "Roman shields were soaked in water and locked together with the shields beside them, which is worth knowing. Faith is described here as protection against things thrown from a distance, the doubts that arrive without warning. Genesis has the same word spoken to a frightened man: I am your shield. The psalm uses feathers instead of wood. In each case the cover is something you did not build."),

                scday("Helmet and sword",
                      ["Hebrews 4:12", "Psalms 119:105", "Matthew 4:4"],
                      "Only one piece of this kit is not defensive, and it is a word rather than a blade. Hebrews calls it living and sharp, able to divide what a person thought was single. The psalm makes it a lamp for the feet, which lights the next step and no further. In the wilderness it is used exactly this way, quietly, one line at a time, against pressure."),

                scday("Praying always",
                      ["Luke 18:1", "1 Thessalonians 5:16-18", "Romans 8:26-27"],
                      "The armour passage ends not with a weapon but with praying always, which is where endurance actually happens. Luke says to pray and not faint, the older word for giving up. Paul asks for prayer without ceasing, meaning a habit rather than a marathon. And when words run out, Romans describes groanings that cannot be uttered doing the work instead. Standing is mostly a matter of staying."),
               ]),

        scplan("wisdom-of-james",
               "The Wisdom of James",
               "Ten days of plain counsel",
               .wisdom,
               "The letter of James is short, blunt and practical, more interested in what a person does on a Tuesday than in what they can explain. Ten days walk through its main themes: trials, listening, speech, and faith that shows. For anyone who wants counsel rather than theory.",
               [
                scday("Count it joy",
                      ["James 1:2-4", "James 1:12"],
                      "James opens with an instruction almost nobody likes: count it joy when trials come. Note the verb. It is an act of accounting, not a feeling summoned on demand. Patience in the older sense meant endurance under load rather than pleasant waiting. What is promised is not rescue but completeness, something finished. The letter will keep this practical tone for five chapters."),

                scday("Ask for wisdom",
                      ["James 1:5-8", "Proverbs 2:6"],
                      "If anyone lacks wisdom, let him ask, and the offer is made without reproach, meaning no one is made to feel foolish for needing it. The double minded man is described as unstable, tossed like water. That is not a warning against doubt so much as against wanting two incompatible things at once. Proverbs says the same source is behind any real understanding."),

                scday("Every good gift",
                      ["James 1:17", "Malachi 3:6"],
                      "The image is astronomical: no variableness, neither shadow of turning, which describes something that does not have phases the way a moon does. Malachi says it in a handful of words about not changing. James is arguing that good things come from a consistent source, so a run of hard weeks is not evidence of a change of mind. Constancy is the quiet subject of both verses."),

                scday("Swift to hear",
                      ["James 1:19-20", "Proverbs 15:1"],
                      "Swift to hear, slow to speak, slow to wrath, in that order, which is the order most conversations get wrong. The older word swift simply means quick. Proverbs adds the mechanics: a soft answer turns away anger, while a harsh word raises it. Neither text asks anyone to have no opinions. They describe timing, and timing is most of what makes a hard conversation survivable."),

                scday("Doers, not hearers",
                      ["James 1:22-24", "James 1:25"],
                      "The image is a man glancing in a mirror and forgetting immediately what he looked like. James is describing something familiar: reading something true, agreeing, and carrying nothing away. The alternative is not more intensity but a longer look, continuing in it. Notice that the blessing attached comes in the doing, not in the knowing. This is a letter allergic to good intentions."),

                scday("Pure religion",
                      ["James 1:27", "Matthew 25:40"],
                      "Asked to define religion, James does not mention belief at all. He names visiting orphans and widows in their affliction and keeping oneself unspotted. Visiting is a small word for a large habit. Matthew makes the same connection from the other side, counting what was done for the least as done directly. Both verses locate faith somewhere specific, usually in the difficult week of another person."),

                scday("Faith and works",
                      ["James 2:14-17", "1 John 3:16-18"],
                      "Wishing someone warmth and food while giving neither is offered as the reduction of a certain kind of faith. James is not attacking belief; he is asking what it produces. John says almost the same in his letter: love in deed and in truth rather than in word and tongue. The test proposed is simple and slightly uncomfortable. What has your conviction cost you lately?"),

                scday("The small rudder",
                      ["James 3:2-4", "James 3:5-6", "Proverbs 18:21"],
                      "Two images in quick succession: a bit in the mouth of a horse and a rudder on a large ship, both tiny and both decisive. Then a spark and a forest. James is unusually blunt about the tongue because he thinks it is the most underestimated thing we own. Proverbs says death and life are in its power. Nothing here suggests silence. It suggests weight, and care."),

                scday("Wisdom from above",
                      ["James 3:17-18", "James 4:6-8"],
                      "The list is worth reading slowly: pure, peaceable, gentle, easy to be entreated, meaning approachable, willing to be persuaded. That last one is rarely counted as wisdom. Chapter four adds that grace goes to the humble, and then the double instruction to draw near and be drawn near to. Wisdom in this letter is a way of being with people, not a store of information."),

                scday("Patience of the farmer",
                      ["James 5:7-8", "James 5:16", "James 4:13-15"],
                      "The farmer waits for the early and later rain and cannot hurry either, which James offers as a model rather than a consolation. The chapter on plans warns against saying we will go to such a city and do business, not because planning is wrong but because it is provisional. And in between sits an instruction to confess to one another. The letter ends where it began, in ordinary company."),
               ]),

        scplan("friendship",
               "Friendship",
               "What the Bible says about friends",
               .love,
               "Seven days on ordinary friendship: why solitude was the first thing called not good, what honest disagreement is for, and how loyalty shows up in the small print. The passages come from Genesis and Proverbs as much as from the gospels. For anyone thinking about the people they keep near.",
               [
                scday("Not good to be alone",
                      ["Genesis 2:18", "Ecclesiastes 4:9-10"],
                      "The first thing called not good in the Bible is solitude. That is a striking place for the judgment to fall, in a garden where everything else has been called good. Ecclesiastes, usually the most skeptical voice in the collection, agrees: two are better than one, and if one falls the other lifts him. The argument is practical. Someone has to be there when you go down."),

                scday("A threefold cord",
                      ["Ecclesiastes 4:12", "Proverbs 18:24"],
                      "A rope of three strands is not merely stronger than one; it holds when a single strand fails, which is a different kind of strength. Proverbs makes a distinction people learn slowly: a man of many companions may come to ruin, while one friend can stick closer than a brother. Quantity and depth are not the same measurement. Most of us have confused them at some point."),

                scday("Iron sharpens iron",
                      ["Proverbs 27:17", "Proverbs 12:15"],
                      "Sharpening involves friction, which is the honest part of the image. A friend who never disagrees with you leaves you exactly as blunt as you were. Proverbs adds that the way of a fool seems right to himself, the whole problem in one line. Nobody sees their own angle. Consider who is currently allowed to tell you something you would rather not hear."),

                scday("Loveth at all times",
                      ["Proverbs 17:17", "Proverbs 10:12", "1 Peter 4:8"],
                      "At all times is the demanding phrase, and it is defined by the second half of the verse: a brother is born for adversity. Proverbs elsewhere says love covers offences, and Peter repeats it. Covering here is not pretending nothing happened. It is declining to broadcast it or to keep it available for later use. Friendships usually end from accumulation rather than from one event."),

                scday("Bear one another",
                      ["Galatians 6:2", "Romans 12:9-10"],
                      "Burden bearing is described as a law, which makes it less optional than the word friendship usually implies. Romans asks for love without dissimulation, meaning without pretending, and for preferring one another in honour. Preferring is an active verb. It suggests going first, offering the credit, noticing aloud. None of this requires a large gesture. It usually requires being the one who reaches out again."),

                scday("Greater love",
                      ["John 15:12-13", "John 13:34-35"],
                      "The greatest love is defined as laying down a life for friends, which most people will never be asked to do literally and are asked to do in fragments constantly. An afternoon given up. A difficult truth told carefully. The new commandment attaches a sign to it: people will know by this. Friendship in these verses is not a private comfort. It is meant to be visible."),

                scday("Where you go",
                      ["Ruth 1:16", "Philemon 1:7", "1 Thessalonians 5:11"],
                      "The words of Ruth are spoken to a bitter mother in law who has told her twice to go home. They are among the most quoted lines about loyalty, and they were not said to a husband or a lover. Paul thanks Philemon for refreshing the hearts of the saints, an unusually warm phrase. Comfort one another, says the earlier letter, and edify, which means build up."),
               ]),
    ]
}
