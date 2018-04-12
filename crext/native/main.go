package main

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"time"
)

func main() {
	log(fmt.Sprintf("Invoked with the following flags: %+v", os.Args))

	s := bufio.NewReader(os.Stdin)
	for {
		data, err := readCommand(s)
		if err != nil {
			log(fmt.Sprintf("Error: %v", err))
		}
		log(fmt.Sprintf("Got data: %s", string(data)))
	}
}

func log(msg string) {
	f, err := os.OpenFile("/tmp/soe_crext_native", os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		return
	}
	defer f.Close()
	s := fmt.Sprintf("%v:%v\n", time.Now().Format(time.RFC850), msg)
	f.WriteString(s)
}

func write(msg []byte) {
	binary.Write(os.Stdout, binary.LittleEndian, uint32(len(msg)))
	os.Stdout.Write(msg)
}

func readCommand(s io.Reader) ([]byte, error) {
	lBuff := make([]byte, 4)
	if _, err := s.Read(lBuff); err != nil {
		return nil, err
	}
	l := readMsgLen(lBuff)

	buff := make([]byte, l)
	if _, err := s.Read(buff); err != nil {
		return nil, err
	}
	return buff, nil
}

func readMsgLen(msg []byte) int {
	var length uint32
	buf := bytes.NewBuffer(msg)
	binary.Read(buf, binary.LittleEndian, &length)
	return int(length)
}
