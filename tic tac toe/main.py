import random, os

class Game:
    def __init__(self):
        self.board = [
            [" ", " ", " "],
            [" ", " ", " "],
            [" ", " ", " "],
        ]

        self.dictionary = {
            "A": 1,
            "B": 2,
            "C": 3,
        }

        self.players = {
            "Player1": "X",
            "Player2": "O",
        }

        self.position = {
            0: "A",
            1: "B",
            2: "C",
        }

        self.names = [
            "Player1",
            "Player2"
        ]
        
        self.winning_positions = [
            [
                "A0",
                "B1",
                "C2",
            ],
            [
                "A0",
                "B0",
                "C0",
            ],
            [
                "A1",
                "B1",
                "C1",
            ],
            [
                "A2",
                "B2",
                "C2",
            ],

            [
                "A0",
                "A1",
                "A2",
            ],

            [
                "B0",
                "B1",
                "B2",
            ],

            [
                "C0",
                "C1",
                "C2",
            ],

            [
                "C0",
                "B1",
                "A2",
            ],
        ]

        self.playing_positions = {
            "Player1": [
                
            ],

            "Player2": [

            ],
        }

        self.playing_player = ""
        self.clear = lambda: os.system('cls')

    def is_slice_in_list(self, s,l):
        return all(item in s for item in l)

    def get_player(self, p):
        return self.players[p]

    def check_for_win(self, p):
        for i in self.winning_positions:
            if self.is_slice_in_list(self.playing_positions[p], i):
                print(f"{p} has won! Good game!")
                return True
        return False
    
    def check_for_draw(self):
        if self.is_board_full():
            print("Draw! Good game!")
            return True
        return False

    def read_input(self, n):
        col, row = self.dictionary[n[0]], n[1]
        return col, row

    def place_val(self, b, n):
        col, row = self.read_input(b)

        value = self.board[int(col) - 1][int(row)]
        if value == " ":
            self.board[int(col) - 1][int(row)] = n
            self.playing_positions[self.playing_player].append(f"{b[0]}{int(row)}")
            self.display_board()
        else:
            self.clear()
            print("This is already taken!")
            self.display_board()

    def display_board(self):
        #self.clear()
        for i in self.board:
            print(i)

    def get_next_player(self):
        k = 0
        for i in self.names:
            if i == self.playing_player:
                if k == 1:
                    self.playing_player = self.names[0]
                    return
                elif k==0:
                    self.playing_player = self.names[1]
                    return
            k += 1

    def is_board_full(self):
        n = 0
        a = 0

        for i in self.board:
            for k in i:
                a+=1
                if not k == " ":
                    n+=1
                else:
                    pass
        return n==a


    def game_loop(self):
            self.get_next_player()
            b = input(f"[{self.playing_player} {self.players[self.playing_player]}] It is your turn! Where to Place?: ").upper()
            self.place_val(b, self.players[self.playing_player])
            if self.check_for_win(self.playing_player):
                return
            else:
                if self.check_for_draw():
                    return
                self.game_loop()

    def main(self):
        print(self.display_board())
        self.playing_player = self.names[random.randint(0, len(self.names) - 1)]
        x = input(f"[{self.playing_player}] It is your turn! Where to Place?: ").upper()
        self.place_val(x, self.players[self.playing_player])

        self.game_loop()

game = Game()
game.main()
