import 'package:flutter/material.dart';
import 'package:flutterapp/fragment/appbar/appbar.dart';
import 'package:flutterapp/fragment/pokedex/PokemonCard.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/pokedex.dart';
import 'package:flutterapp/pokemon.dart';
import 'package:flutterapp/webservice.dart';
import 'package:flutterapp/globals.dart' as globals;

class PokedexView extends StatefulWidget {
  final Pokedex pokedex;

  const PokedexView.pok({Key key, @required this.pokedex}) : super(key: key);

  @override
  _PokedexState createState() => _PokedexState(pokedex);
}

class _PokedexState extends State<PokedexView> {
  Pokedex pokedex;
  _PokedexState(Pokedex pokedex){this.pokedex = pokedex;}
  @override
  void initState() {
    super.initState();
    for(Pokemon p in globals.savedPokemon){
      pokedex.getPokemonById(p.id).saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarView(title : "PokeFlex",pokedex: pokedex, icon : Icons.collections_bookmark, activateFavorites: true),
      body: getPokedexWidget()
    );
  }

  Widget getPokedexWidget(){
    if(pokedex?.pokemonsList?.isEmpty ?? true){
      return FutureBuilder<Pokedex>(
        future: WebService.fetchPokedex(),
        builder: (BuildContext context, AsyncSnapshot<Pokedex> snapshot) {
          if (!snapshot.hasData) return new Center(child : new CircularProgressIndicator());
          return new GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.3,
            children: snapshot.data.pokemonsList.map((Pokemon pok) {
              return new PokemonCardView.id(id: pok.id, pokedex: pokedex);
            }).toList(),
          );
        },
      );
    }else{
      return new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.3,
        children: pokedex.pokemonsList.map((Pokemon pok) {
          return new PokemonCardView.id(id: pok.id, pokedex: pokedex);
        }).toList(),
      );
    }
  }
}