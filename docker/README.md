# Docker

## Usage

Generate the database password and JWT secrets with the following command

```
echo "DB_PASSWORD=$(openssl rand -base64 36 | tr -d '\n')" >> .env
echo "JWT_ACCESS_SECRET=$(openssl rand -base64 60 | tr -d '\n')" >> .env
echo "JWT_REFRESH_SECRET=$(openssl rand -base64 60 | tr -d '\n')" >> .env
```

Start the containers with

```
docker compose up -d
```

## Martin

The tile server `maplibre/martin` is optional and allows you to self host your own map

Download [Natural Earth Vector Tiles](https://klokantech.github.io/naturalearthtiles/) place it into `docker/tiles` and rename it to `ne2sr.mbtiles`

If you want to self host a map of whole planet then download an build from one of the two vector map technologies

- [OpenFreeMap](https://github.com/hyperknot/openfreemap/tree/main#faq) (planet.mbtiles)
- [Protomaps](https://docs.protomaps.com/basemaps/downloads)

## OpenFreeMap Styles

**Liberty** - forked from https://github.com/maputnik/osm-liberty

**Dark** - forked from https://github.com/openmaptiles/dark-matter-gl-style
