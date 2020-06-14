Geo masterdate
==============

Athena や PostGIS などから利用するための地理情報空間マスターデータの作成を行う。

元データは主に ESRI Shapefile 形式を想定している。


## Requirement

データの生成には下記モジュールに依存しているため、事前にインストールが必要となる。

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)


## Usage

各データにおけるマスターデータ作成方法などについて説明する。
なお、作成データは `output` ディレクトリ配下に出力される。
出力されるデータの測地系は `EPSG:4326` となっている。

### mesh2r & mesh3r

地域メッシュの 2 次メッシュと 3 次メッシュデータの作成を行う。
入力元データは [Ｇ空間情報センターのメッシュデータ](https://www.geospatial.jp/ckan/dataset/biodic-mesh) を想定している。

``` shell
$ make mesh2r SHAPE=/path/to/mesh2r/shapefile.shp
$ make mesh3r SHAPE=/path/to/mesh3r/shapefile.shp
```

出力データの形式は下記のようになっている。

- メッシュコード
- 形状(WKT)

