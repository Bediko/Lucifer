#encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'password'

fach= { 
    "Mathematik 1"                                      => "MAT1",
    "Digitaltechnik"                                    => "DIG",
    "Einführung in die Programmierung"                  => "EPR",
    "Rechnerarchitektur"                                => "RAR",
    "Mathematik 2"                                      => "MAT2",
    "Mikroprozessortechnik"                             => "MPT",
    "Algorithmen und Datenstrukturen"                   => "ALD",
    "Betriebssysteme"                                   => "BSY",
    "Objektorientierte Anwendungsentwicklung"           => "OOA",
    "Betriebswirtschaft und Marketing"                  => "BWM",
    "Statistik"                                         => "STA",
    "Graphische Datenverarbeitung und Bildverarbeitung" => "GRA",
    "Interaktive Systeme"                               => "IAS",
    "Theoretische Konzepte"                             => "THK",
    "Datennetze und Datenübertragung"                   => "DNU",
    "Datenbanksysteme"                                  => "DBS",
    "Datennetzmanagement"                               => "DNM",
    "Web Engineering"                                   => "WEB",
    "Wahlpflichtmodul Vorlesung 1"                      => "WPV1",
    "Numerik für Informatiker"                          => "NUM",
  }
https://gist.github.com/3304006
agent = Mechanize.new
page = agent.get('https://studinfo.hsnr.de/qisserver/servlet/de.his.servlet.RequestDispatcherServlet?state=user&type=0&application=qispos')

puts "Mtnr?"
mtnr= gets
password = Password.get("Password?")

login_form = page.form('loginform')
login_form.asdf = mtnr
login_form.fdsa = password
page = agent.submit(login_form, login_form.buttons.first)
begin
  page = agent.page.link_with(:text =>'Notenspiegel').click
rescue
  pp 'Mtnr oder Password falsch'
  exit
end

notenspiegel=0.0
anzahl=0.0

page.search('tr').each do |row|
  name,note,credits = row.xpath('./td[2] | ./td[4] | ./td[6]')
  if name && note   
    nbsp = Nokogiri::HTML("&nbsp;").text
    note=note.content.gsub(nbsp,"").gsub(",",".");
    credits=credits.content.gsub(nbsp,"");
    name=name.content.gsub(nbsp,"");
    next if note.empty?
    print fach[name]+"\t"+note+"\t"+credits+"\n"
    notenspiegel+=note.to_f*credits.to_f
    anzahl+=credits.to_f
  end
end
notenspiegel=notenspiegel/anzahl
puts notenspiegel

