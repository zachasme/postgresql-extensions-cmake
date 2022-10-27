\set epsilon 0.0000000000001
\set lyon POINT(4.8422, 45.7597)
\set paris POINT(2.3508, 48.8567)

SELECT dependant('8a283082a677fff');

SELECT h3_great_circle_distance(:lyon, :paris, 'km') - 392.21715988417765 < :epsilon;
