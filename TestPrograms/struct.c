struct polygon {
    int points;
    int x1, x2, x3, x4;
    int y1, y2, y3, y4;
};

int main () {
    struct polygon myPoly;
    myPoly.x1 = 1;
    myPoly.x2 = 1;
    myPoly.x3 = 1;
    myPoly.x4 = 1;
    myPoly.y1 = 1;
    myPoly.y2 = 1;
    myPoly.y3 = 1;
    myPoly.y4 = 1;
    myPoly.points = 4;

    return 0;
}
