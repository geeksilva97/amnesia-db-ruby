HEADER
numero de chaves (8-bit) | timestamp (64-bit) -> 9 bytes

BLOCO
tamanho do bloco (16-bit) | tamanho do registro (7-bit) | tombstone? (1-bit) | timestamp (64-bit) | tamanho da chave (8-bit) | chave (x bytes) | tamanho do valor (8-bit) | valor (y bytes)