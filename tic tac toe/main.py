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

        self.names = [
            "Player1",
            "Player2"
        ]

        self.playing_player = ""
        self.clear = lambda: os.system('cls')

    def get_player(self, p):
        return self.players[p]

    def read_input(self, n):
        col, row = self.dictionary[n[0]], n[1]
        return col, row

    def place_val(self, b, n):
        col, row = self.read_input(b)

        value = self.board[int(col) - 1][int(row)]
        if value == " ":
            self.board[int(col) - 1][int(row)] = n
            self.display_board()
        else:
            print("This is already taken!")
            pass

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
    
    def check_win(self, n):
        b=0
        for p in self.board:
            for k in p:
                for item in k:
                    if item == n:
                        b=+1
                    #horizontal
        if b>=3:
            print(f"{self.playing_player} has won!")
            return
        
        

    def game_loop(self):
            self.get_next_player()
            b = input(f"[{self.playing_player}] It is your turn! Where to Place?: ").upper()
            self.place_val(b, self.players[self.playing_player])
            self.check_win(self.players[self.playing_player])

            self.game_loop()
            

    def main(self):
        print(self.display_board())
        self.playing_player = self.names[random.randint(0, len(self.names) - 1)]
        x = input(f"[{self.playing_player}] It is your turn! Where to Place?: ").upper()
        self.place_val(x, self.players[self.playing_player])

        self.game_loop()


game = Game()
game.main()
