package main

// the package import list
import (
    "fmt"
    "os"
    "image"
    "image/png"
)

//creates a board type
type Board struct {
    Image *image.RGBA
    evolution int
}

//constructor (static, returns pointer)
func NewBoard(width, height int) *Board {
    //initialize and return reference
    board := &Board{ image.NewRGBA(width,height), 0 }

    //iterate over image and initialize data
    //note: no range over 2D matrices,Image type
    for y := 0; y <height; y++ {
        for x := 0; x <width; x++ {
            //explicit casting
            var gray_x = byte(x * 255 / width)
            var gray_y = byte(y * 255 / height)
            var gray = byte((x*255/width + y*255/height)/2)
            //create color struct
            var col = image.RGBAColor{gray_x,gray_y,gray,255}
            //assignment, note no -> operator in go. 
            // . and -> knows which to do
            board.Image.Set(x,y,col)
        }
    }

    return board
}

//because go provides no basic math on prim types other than float
func min(a,b int) int {
    if a < b {
        return a
    }
    return b
}

func max(a,b int) int {
    if a > b {
        return a
    }
    return b
}

//Evolve "member" for Board
func (b *Board) Evolve() {
    //cache width and height, not sure 
    //how optimizers cache or recheck every loop?
    var width = b.Image.Rect.Dx()
    var height = b.Image.Rect.Dy()

    //allocate output (no in place way of doing it)
    outImage := image.NewRGBA(width,height)

    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            //without .(image.RGBAColor) type col stays
            //as RGBA but later accessed as "Color"
            //some "interface" voodoo
            col := b.Image.At(x,y).(image.RGBAColor)

            //multiple assignment/return
            var sumRed, sumGreen, sumBlue = 0, 0, 0

            //check neighbours
            for dy := -1; dy <= 1; dy++ {
                for dx := -1; dx <= 1; dx++ {
                    //returns black if not in bounds
                    col_n := b.Image.At(x+dx,y+dy).(image.RGBAColor)
                    sumRed += int(col_n.R)
                    sumGreen += int(col_n.G)
                    sumBlue += int(col_n.B)
                }
            }

            //too much casting, ewww
            //also, go throws on overflows.. 
            if sumGreen > 255*3 {
                col.R = byte(max(255,int(col.G) + sumBlue/8))
            } else {
                col.R = byte(min(255,int(col.G) + sumBlue/8))
            }

            if sumBlue > 255*3 {
                col.G = byte(max(255,int(col.B) + sumRed/8))
            } else {
                col.G = byte(min(255,int(col.B) + sumRed/8))
            }

            if sumRed > 255*3 {
                col.B = byte(max(255,int(col.R) + sumGreen/8))
            } else {
                col.B = byte(min(255,int(col.R) + sumGreen/8))
            }

            //setter (assume checks bounds)
            outImage.Set(x,y,col)
        }
    }

    //replace old image with new generation
    b.Image = outImage

    //postfix operator does not return value
    b.evolution++
}

func (b* Board) Write() {
    //is there a diff between var x = , and x:=  ????
    //afaict var x excludes pointers
    var fileName = fmt.Sprintf("./%000d.png",b.evolution)

    //open writer and save image (minimal error handling)
    outFile, err := os.Open(fileName, os.O_CREAT | os.O_WRONLY, 0666)
    if err != nil {
        panic(fmt.Sprintf("%v\n",err))
    }
    defer outFile.Close()

    err2 := png.Encode(outFile,b.Image)
    if err2 != nil {
        panic(fmt.Sprintf("%v\n",err2))
    }
}

func main() {

    const (
        height = 512
        width = 512
        generations = 100
    )

    b := NewBoard(width,height)
    for i := 0 ; i < generations ; i++ {
        b.Evolve()
    }

    b.Write()

}
