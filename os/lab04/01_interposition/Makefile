CC = gcc
CFLAGS = -Wall -fPIC
LDFLAGS = -ldl -lm

TARGET = solution
LIBFREDJOHN = llibinterpose.a
LIBBILLSAM = libbillsam.so

all: $(TARGET)

fred.o: fred.c lib.h
	$(CC) $(CFLAGS) -c $< -o $@
 
john.o: john.c lib.h
	$(CC) $(CFLAGS) -c $< -o $@

$(LIBFREDJOHN): fred.o john.o
	ar rcs $@ $^

$(LIBBILLSAM): bill.c sam.c
	$(CC) $(CFLAGS) -shared -o $@ $^ $(LDFLAGS)

$(TARGET): solution.c $(LIBFREDJOHN) $(LIBBILLSAM)
	$(CC) $(CFLAGS) -o $@ solution.c -L. $(LIBFREDJOHN) -lbillsam -Wl,-rpath=. -lm

run: $(TARGET) $(LIBBILLSAM)
	LD_PRELOAD=./$(LIBBILLSAM) ./$(TARGET)
	ldd ./$(TARGET)

clean:
	rm -f $(TARGET) *.so *.a *.o