import 'dart:convert'; //jsoncode :)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;//pegar dados web
import 'package:google_fonts/google_fonts.dart';  //pegar uma fonte medieval
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Lista para receber as criptos
  List cryptoData=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCryptoData();//inicializa pegando os valores da cripto do dia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1B16),
      appBar: AppBar(title: Text("API Binance, ultimas 24hrs"),backgroundColor: Color(0xFFB6862C),),
      body: ListView(
        shrinkWrap: true,//Garante que o listview use só o espaço necessário
        physics: NeverScrollableScrollPhysics(),//impede o scroll
        children: [
          Image.asset("lib/assets/mercado feudal.jpg", fit: BoxFit.fitWidth, height: 200,),
          SizedBox(
            height: 500,
            width: 500,
            child: ListView.builder(
              itemCount: cryptoData.length, 
              itemBuilder: (context, index){
                final crypto=cryptoData[index];//pegando os dados de cada cripto e atribuindo a uma variavel
                return Padding(padding: EdgeInsetsGeometry.all(8), 
                child: Container(
                  color: const Color(0xFF556B2F),
                    child: ListTile(
                      title: Text(
                      crypto['symbol'],
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE0D8C3), // pergaminho
                      ),
                    ),
                      subtitle: Text(
                        "Preço: ${crypto['lastPrice']} " +
                        (double.parse(crypto['lastPrice']) <= 1//verificar qualidade se, trata de cobre, prata ou ouro
                        ?"em cobres"
                        :(double.parse(crypto['lastPrice']) <= 800
                          ?"em pratas"
                          :(double.parse(crypto['lastPrice'])) <= 10000
                            ?"em ouro"
                            :"em diamante")) +
                          "\nMenor preço nas ultimas 24hr: ${crypto['lowPrice']}\nMaior preço nas ultimas 24hr: ${crypto['highPrice']}",
                          style: GoogleFonts.cinzel(
                            fontSize: 18,
                            color: Color(0xFFF5ECD7), // pergaminho
                  ),
                ),                  
              ),
              ),
              
              );
            }),
          )
        ],
      ),
    );
  }
  //Funcao que pegue os dados das criptos
  Future<void> _fetchCryptoData() async{//sendo do tipo future, pois como vem da internet os valores, sao assicronos e futuros,
    final response=await http.get(//pegando e utilizando da biblioteca http para usar o metodo get, pegando as informacoes da url, que vem a api
      Uri.parse('https://api.binance.com/api/v3/ticker/24hr')
    );
    if (response.statusCode==200) {//se o codigo for 200, quer dizer que esta valido
      setState(() {
        cryptoData=jsonDecode(response.body).where((crypto)=>double.parse(crypto['lastPrice'])>=0.00000001).toList();
      });
    }else{//nao necessariamente seria erro, existe diveros codigos retornaveis cada qual quer dizer alguma coisa, exemplo 202, 404, 500...
      throw Exception('Failed to load crypto data!');
    }
  }
}