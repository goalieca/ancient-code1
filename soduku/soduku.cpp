#include <iostream>

struct Board
{
    // board[col][row]
    char marked[9][9];
    bool guesses[9][9][9];

    Board(char input[9][9])
    {
        for (int y=0;y<9;y++)
        {
            for (int x=0; x<9; x++)
            {
                marked[y][x] = input[y][x];
                // if unfilled then it could be any number potentially
                for (int i=0;i<9;i++)
                {
                    guesses[y][x][i] = (marked[y][x]<=0);
                }
            }
        }
    }

    Board(const Board& b)
    {
        for (int y=0;y<9;y++)
        {
            for (int x=0;x<9;x++)
            {
                marked[y][x] = b.marked[y][x];
                for (int i=0;i<9;i++)
                {
                    guesses[y][x][i] = b.guesses[y][x][i];
                }
            }
        }
    }

    void make_guess()
    {
        while(true)
        {
            int rx = rand()%9;
            int ry = rand()%9;
            
            if (marked[ry][rx])
                continue;

            // pick the ith guess (wrap around)
            int ri = rand()%9;
            int i=0;
            while (ri > 0)
            {
                for (i=0;i<9;i++)
                {
                    if (guesses[ry][rx][i])
                        ri--;
                    if (ri == 0)
                        break;
                }
            }
            
            // try this one
            for (int j=0; j<9; j++)
            {
                if (j != i)
                {
                    guesses[ry][rx][i] = false;
                }
            }
            break;
        }
    }

    void check_rows()
    {
        for (int y=0; y<9; y++)
        {
            //collect numbers in the row
            bool nums[9] = {false};
            //and the numbers occurents
            char cnt_guess[9] = {0};

            for (int x=0;x<9;x++)
            {
                if (marked[y][x] > 0)
                    nums[marked[y][x]-1] = true;
            }

            //now to refine the guesses
            for (int i=0;i<9;i++)
            {
                if (nums[i])
                {
                    for (int x=0;x<9;x++)
                    {
                        guesses[y][x][i] = false;
                    }
                }
            }

            //count the number of times a particular guess occurs
            for (int x = 0; x<9; x++)
            {
                for (int i=0;i<9;i++)
                {
                    if (guesses[y][x][i])
                        cnt_guess[i]++;
                }
            }

            //if the guess only occurs once then remove the other numbers
            //as plausible
            for (int i=0; i<9; i++)
            {
                if (cnt_guess[i] == 1)
                {
                    for (int x=0;x<9;x++)
                    {
                        if (guesses[y][x][i])
                        {
                            for (int j=0;j<9;j++)
                            {
                                if (j != i)
                                    guesses[y][x][j] = false;
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    void check_cols()
    {
        for (int x=0; x<9; x++)
        {
            //collect numbers in the row
            bool nums[9] = {false};
            char cnt_guess[9] = {0};
            for (int y=0;y<9;y++)
            {
                if (marked[y][x] > 0)
                    nums[marked[y][x]-1] = true;
            }

            //now to refine the guesses
            for (int i=0;i<9;i++)
            {
                if (nums[i])
                {
                    for (int y=0;y<9;y++)
                        guesses[y][x][i] = false;
                }
            }

            //count the number of times a particular guess occurs
            for (int y = 0; y<9; y++)
            {
                for (int i=0;i<9;i++)
                {
                    if (guesses[y][x][i])
                        cnt_guess[i]++;
                }
            }

            //if the guess only occurs once then remove the other numbers
            //as plausible
            for (int i=0; i<9; i++)
            {
                if (cnt_guess[i] == 1)
                {
                    for (int y=0;y<9;y++)
                    {
                        if (guesses[y][x][i])
                        {
                            for (int j=0;j<9;j++)
                            {
                                if (j != i)
                                    guesses[y][x][j] = false;
                            }
                            break;
                        }
                    }
                }
            }
        }
    }

    void check_squares()
    {
        for (int y=0; y<3; y++)
        {
            for (int x=0; x<3; x++)
            {
                bool nums[9] = {false};
                char cnt_guess[9] = {0};
           
                //collect numbers in the square
                for (int y1 = 0; y1<3; y1++)
                {
                    for (int x1 = 0; x1<3; x1++)
                    {
                        int j = x*3 + x1;
                        int k = y*3 + y1;
                        if (marked[k][j] != 0)
                            nums[marked[k][j]-1] = true;
                    }
                }

                //now refine the guesses
                for (int m = 0; m<9; m++)
                {
                    if (nums[m])
                    {
                        for (int y1 = 0; y1<3; y1++)
                        {
                            for (int x1 = 0; x1<3; x1++)
                            {
                                int j = x*3 + x1;
                                int k = y*3 + y1;
                                guesses[k][j][m] = false;
                            }
                        }
                    }
                }

                //count the number of times a particular guess occurs
                for (int y1 = 0; y1<3; y1++)
                {
                    for (int x1 = 0; x1<3; x1++)
                    {
                        int j = x*3 + x1;
                        int k = y*3 + y1;
                        for (int i=0;i<9;i++)
                        {
                            if (guesses[k][j][i])
                                cnt_guess[i]++;
                        }
                    }
                }

                //if the guess only occurs once then remove the other numbers
                //as plausible
                for (int i=0; i<9; i++)
                {
                    if (cnt_guess[i] == 1)
                    {
                        for (int y1=0;y1<3;y1++)
                        {
                            for (int x1=0;x1<3;x1++)
                            {
                                int j = x*3 + x1;
                                int k = y*3 + y1;
                                if (guesses[k][j][i])
                                {
                                    for (int m=0;m<9;m++)
                                    {
                                        if (m != i)
                                            guesses[k][j][m] = false;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }

            }
        }   
    }

    // returns true if there was a guess that passed
    bool apply_guesses()
    {
        // were we able to advance?
        bool updated = false;

        for (int y=0;y<9;y++)
        {
            for (int x=0;x<9;x++)
            {
                if (marked[y][x] > 0)
                    continue;

                //if the only guess then must be the answer
                int cnt = 0;
                int last_guess = 0;
                for (int j=0;j<9;j++)
                {
                    if (guesses[y][x][j])
                    {
                        cnt++;
                        last_guess = j; 
                    }
                }
                
                if (cnt == 1)
                {
                    updated = true;
                    marked[y][x] = last_guess+1;
                }
            }
        }

        return updated;
    }

    bool is_done()
    {
        for (int y = 0; y<9; y++)
        {
            for (int x= 0; x<9; x++)
            {
                if (marked[y][x] == 0)
                    return false;
            }
        }

        return true;
    }

    void print_board()
    {
        for (int y=0;y<9;y++)
        {
            printf("%hhu %hhu %hhu | %hhu %hhu %hhu | %hhu %hhu %hhu\n",
                marked[y][0],marked[y][1],marked[y][2],
                marked[y][3],marked[y][4],marked[y][5],
                marked[y][6],marked[y][7],marked[y][8]);
            if (y == 2 || y == 5)
                printf("--------------------\n");
        }
    }

    bool run()
    {
        while(!is_done())
        {
            check_rows();
            check_cols();
            check_squares();
            if (!apply_guesses())
                return false;
        }
        return true;
    }

};

int main(int argc, char** argv)
{
    char board[9][9] = {{0,5,8,0,0,0,0,0,0},
                        {3,0,0,0,2,0,0,0,0},
                        {0,0,7,0,0,9,0,0,0},
                        {0,7,0,5,0,0,0,0,0},
                        {2,0,1,0,0,0,7,0,4},
                        {0,4,5,0,0,0,0,9,0},
                        {0,0,2,0,8,0,0,1,5},
                        {0,0,0,3,0,0,9,7,8},
                        {0,3,0,0,0,0,0,2,0}};

    Board b(board);

    b.print_board();
    printf("\n");

    int guesses = 0;    

    while(!b.run())
    {
        Board c(b);
        c.make_guess();
        guesses++;
        if (c.run())
        {
            b = c;
            break;
        }
    }

    printf("board found in %d guesses\n",guesses);
    b.print_board();
    return 0;


}

