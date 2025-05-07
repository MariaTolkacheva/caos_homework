CC = gcc
CFLAGS = -Wall -Wextra -std=c2x -fPIC
LDFLAGS = -ldl -lm

TARGET = solution
LIB1 = libfredjohn.so
LIB2 = libbillsam.so

all: $(TARGET)

$(LIB1): fred.c john.c
	$(CC) $(CFLAGS) -shared -o $@ $^ $(LDFLAGS)

$(LIB2): bill.c sam.c
	$(CC) $(CFLAGS) -shared -o $@ $^ $(LDFLAGS)


$(TARGET): solution.c $(LIB1) $(LIB2)
	$(CC) $(CFLAGS) -o $@ solution.c -L. -lfredjohn -lbillsam -Wl,-rpath=.

run: $(TARGET) $(LIB2)
	LD_PRELOAD=./$(LIB2) ./$(TARGET)

clean:
	rm -f $(TARGET) $(LIB1) $(LIB2) *.o
