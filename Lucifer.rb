#encoding: UTF-8
require 'rubygems'
require 'mechanize'
require 'read-password'

subject= {
  "Mathematik 1"                                      => "MAT1",
  "Digitaltechnik"                                    => "DIG",
  "Einführung Programmierung"                         => "EPR",
  "Rechnerarchitektur"                                => "RAR",
  "Mathematik 2"                                      => "MAT2",
  "Mikroprozessortechnik"                             => "MPT",
  "Algorithmen+Datenstruktur"                         => "ALD",
  "Betriebssysteme"                                   => "BSY",
  "Objektorient.Anwend.Entwi"                         => "OOA",
  "Betriebswirt.+Marketing"                           => "BWM",
  "Statistik"                                         => "STA",
  "Graphische DV+Bildverarb."                         => "GRA",
  "Interaktive Systeme"                               => "IAS",
  "Theoretische Konzepte"                             => "THK",
  "Datennetze+Datenübertrag."                         => "DNU",
  "Datenbanksysteme"                                  => "DBS",
  "Datennetzmanagement"                               => "DNM",
  "Web Engineering"                                   => "WEB",
  "WahlpflichtmodVorlesung 1"                         => "WPV1",
  "Algorithmen Datenstruktur"                         => "ALD",
  "Datennetze Datenübertragu"                         => "DNU",
  "Wahlpflichtmod Hauptsemin"                         => "WPS2",
  "Wahlpflichtmodul Projekt"                          => "WPP",

}
agent = Mechanize.new
begin
  page = agent.get('https://studinfo.hsnr.de/qisserver/servlet/de.his.servlet.RequestDispatcherServlet?state=user&type=0&application=qispos')
rescue => e
  p e.message
end

if ARGV[0]
  mtnr=ARGV[0]
else
  puts "Mtnr?"
  mtnr= gets
end

password = Kernel::password()

login_form = page.form('loginform')
login_form.asdf = mtnr
login_form.fdsa = password
page = agent.submit(login_form, login_form.buttons.first)
begin
  page = agent.page.link_with(text: 'Notenspiegel').click
  page= agent.page.link_with(text: 'Bachelor BA Informatik').click
rescue
  pp 'Mtnr oder Password falsch'
  exit
end

gpa=0.0
count=0.0

page.search('tr').each do |row|
  name,grade,credits = row.xpath('./td[2] | ./td[4] | ./td[6]')
  if name && grade
    nbsp = Nokogiri::HTML("&nbsp;").text
    grade=grade.content.gsub(nbsp,"").gsub(",",".");
    credits=credits.content.gsub(nbsp,"");
    name=name.content.gsub(nbsp,"");
    next if grade.empty?
    if subject[name]
      print subject[name]+"\t"+grade+"\t"+credits+"\n" 
    else
      print name+"\t"+grade+"\t"+credits+"\n"
    end
    gpa+=grade.to_f*credits.to_f
    count+=credits.to_f
  end
end
gpa=gpa/count
puts gpa.round(1)
