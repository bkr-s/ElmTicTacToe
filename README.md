# ElmTicTacToe

## Task
Write an unbeatable Tic Tac Toe program in a language you've never used before.

-[x] 2 player - Human vs Human  
-[x] 1 player - Human vs Easy Computer  
-[] 1 player - Human vs Unbeatable Computer

## Code
Language chosen: [Elm]("https://elm-lang.org)

## To get started
Pre-requisite: The following steps assume that you have [npm]("https://www.npmjs.com") installed on your local machine.

1. Clone this repository to your local machine
2. `$ cd ` into the directory that the repository was cloned to
3. Install the packages needed to run the files with `$ npm install`.

### Testing
```npm run test```

### Launch the game
```npm run build```

### Linting
This project uses the JetBrains [Elm]("https://plugins.jetbrains.com/plugin/10268-elm/") plugin which auto formats on save

_________
### Things I would like to work on:

1. Delay computer move for easy computer: had issues with type errors when returning (Model, Cmd Msg) rather than just Model. Was able to change it for Main.update and any functions it referenced, but (Model, Cmd Msg) clashed with the Browser.sandbox call in Main.main. A delayed move selection by the computer would make for better UX

2. Randomise computer move: Similarly ran into issues with types. Random returns a Generator. Possible way around this is to pass the generator as a Cmd Msg. Random move selection by the computer makes for better UX

3. Randomise player allocation when game starts (Cmd msg)

4. Unbeatable computer player: I did have a look at some MiniMax examples. I have a basic understanding of the algorithm applied in other languages. Couldn't quite get my head around it in Elm. Only a light touch to understand how it works (time-boxed to one hour). I attempted a heuristic strategy a few times using Wikipedia as a source. I've attached a markdown `Strategy.md` to walk through my initial step-by-step.

5. Improve styling to web-page: 
    - Responsive resizing offsets the cells from the grid background in smaller windows 
    - Add highlight to winning line when the game ends to make the win more apparent
    - Add background

6. Possibly reduce Main.elm further. I extracted some data structures which seemed to emerge

_________

### Reflection
- When I initially approached the project I started off in a very OO manner, building a board module first
- As I continued to ramp up it became apparent that the game "loop" would emerge from the Model - View - Update cycle 
- Found that after watching a talk by the creator and starting Main.elm, things went a bit smoother. Focusing on the Model, custom types and using cases to steer the flow of the game really helped