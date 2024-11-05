using LibPQ

conn = LibPQ.Connection(
    "host=185.139.1.29 port=15711 dbname=primos user=jotas password=15711PrImOs"
)

LibPQ.execute(conn, """
  INSERT INTO public.mersenne_lines
  (line, p_line, p, bsp, prime_parent)
  VALUES(0, 0, 0, 0, 5);
"""
)