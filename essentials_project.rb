system("clear") or system("cls")
require 'socket'		# => buat socket

puts """
            ███████╗███████╗███████╗███████╗███╗   ██╗████████╗██╗ █████╗ ██╗     ███████╗
            ██╔════╝██╔════╝██╔════╝██╔════╝████╗  ██║╚══██╔══╝██║██╔══██╗██║     ██╔════╝
            █████╗  ███████╗███████╗█████╗  ██╔██╗ ██║   ██║   ██║███████║██║     ███████╗
            ██╔══╝  ╚════██║╚════██║██╔══╝  ██║╚██╗██║   ██║   ██║██╔══██║██║     ╚════██║
            ███████╗███████║███████║███████╗██║ ╚████║   ██║   ██║██║  ██║███████╗███████║
            ╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝
                                                                                          
                        ██████╗ ██████╗  ██████╗      ██╗███████╗ ██████╗████████╗        
                        ██╔══██╗██╔══██╗██╔═══██╗     ██║██╔════╝██╔════╝╚══██╔══╝        
                        ██████╔╝██████╔╝██║   ██║     ██║█████╗  ██║        ██║           
                        ██╔═══╝ ██╔══██╗██║   ██║██   ██║██╔══╝  ██║        ██║           
                        ██║     ██║  ██║╚██████╔╝╚█████╔╝███████╗╚██████╗   ██║           
                        ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚════╝ ╚══════╝ ╚═════╝   ╚═╝    

yang kamu mau:
   1. port scanner
   2. services scanning
   3. ftp exploiter        [bonus]       
"""

# satu file aja ya cok! males gue kabeh
def port_scanner(rhost,port)
	r = Time.new
	d = r.strftime("%H:%M")
	info = "\033[1;33m[\033[1;32m#{d}\033[1;33m][\033[1;31mINFO\033[1;33m] \033[1;37m"
	s = Socket.new(:INET,:STREAM)
	rhost = Socket.sockaddr_in(port,rhost)
	begin 
		s.connect_nonblock(rhost)
	rescue Errno::EINPROGRESS
	end
	_, sockets, _ = IO.select(nil,[s],nil)
	if sockets
		puts "#{info}port => #{port} open"
	else
		# => null
	end
	s.close()
end

def port_scan
	plist = [21,22,23,25,53,80,443,3306,8080,4409,3333]
	printf("ip/host/web target   :   ")
	ip = gets.chomp
	threads   = []
	plist.each { |i| threads << Thread.new { port_scanner(ip,i) } }
	threads.each(&:join)
end

def service
	printf("target host [rhost]  :   ")
	x = gets.chomp
	r = Time.new
	d = r.strftime("%H:%M")
	info = "\033[1;33m[\033[1;32m#{d}\033[1;33m][\033[1;31mINFO\033[1;33m] \033[1;37m"
	puts "#{info}dalam scanning services. saya akan melakukan manual port => 80"
	s = TCPSocket.new(x,80)
	puts "#{info}koneksi berhasil"
	s.write("Who Are You\r\n")	# => ya bisa tau lah. banner grabbing
	puts "#{info}berhasil send ke client.\n#{info}getting data"
	s.read(100)
end

def exploit
	puts "[!] information: anda harus satu koneksi dengan target"
	printf("\nTarget host   :   ")
	rhost = gets.chomp
	s = TCPSocket.new(rhost,21)
	puts "#{info}connected!"
	while true
		printf("essentials >  ")
		x = gets.chomp
		s.write(x)
		s.recv(100)
	end
end

r = Time.new
d = r.strftime("%H:%M")
info = "\033[1;33m[\033[1;32m#{d}\033[1;33m][\033[1;31mINFO\033[1;33m] \033[1;37m"

while true
	printf("opsi  _>  ")
	x = gets.chomp
	case x
	when '1'
		port_scan
	when '2'
		service
	when '3'
		exploit 
	else
		puts "\033[1;31m[!] \033[1;32mSalah opsi"
	end
end