import json

# Livro enum indices (genesis=0, ordem canonica)
GENESIS, SALMOS, PROVERBIOS, ISAIAS = 0, 18, 19, 22
MATEUS, JOAO, ROMANOS, FILIPENSES = 39, 42, 44, 49

# Severidade: agradecimento0 normal1 importante2 urgente3
# Categoria: saude0 profissional1 pessoal2 casa3 relacionamento4 outro5
SAUDE, PROFISSIONAL, PESSOAL, CASA, RELACIONAMENTO = 0, 1, 2, 3, 4
AGRADEC, NORMAL, IMPORTANTE, URGENTE = 0, 1, 2, 3

def pedido(pid, texto, sev, cat, criada, respondida=None):
    return {"id": pid, "texto": texto, "severidade": sev, "categoria": cat,
            "criadaEm": criada, "respondidaEm": respondida,
            "respondida": respondida is not None}

# --- Lista de oracao: 5 em oracao + 3 respondidas ---
p_vovo    = pedido("s1-vovo",    "Saúde da vovó Maria depois da cirurgia", URGENTE,    SAUDE,          "2026-09-10T20:00:00.000")
p_emprego = pedido("s2-emprego", "Emprego novo do Antônio",                IMPORTANTE, PROFISSIONAL,   "2026-09-05T20:00:00.000")
p_pac     = pedido("s3-pac",     "Paciência com as crianças de manhã",     NORMAL,     PESSOAL,        "2026-08-28T20:00:00.000")
p_casa    = pedido("s4-casa",    "A reforma do telhado antes das chuvas",  NORMAL,     CASA,           "2026-08-20T20:00:00.000")
p_irma    = pedido("s5-irma",    "A viagem da irmã Clara para o interior", NORMAL,     RELACIONAMENTO, "2026-08-12T20:00:00.000")

r_consulta = pedido("s6-consulta", "A consulta da vovó saiu bem",                    AGRADEC, SAUDE,          "2026-08-30T20:00:00.000", "2026-09-09T20:00:00.000")
r_vizinhos = pedido("s7-vizinhos", "Os vizinhos novos receberam a gente tão bem",    AGRADEC, RELACIONAMENTO, "2026-08-22T20:00:00.000", "2026-09-03T20:00:00.000")
r_prova    = pedido("s8-prova",    "A prova do Antônio no trabalho passou",          AGRADEC, PROFISSIONAL,   "2026-07-30T20:00:00.000", "2026-08-14T20:00:00.000")

oracoes = [p_vovo, p_emprego, p_pac, p_casa, p_irma, r_consulta, r_vizinhos, r_prova]

def leitura(livro, cap, v1, v2=None):
    return {"livro": livro, "capitulos": [cap], "versiculos": [v1] + ([v2] if v2 else [])}

def culto(cid, data, quem, leituras, pedidos):
    return {"id": cid, "data": data, "quemOrou": quem,
            "leituraFeita": leituras, "pedidosOracao": pedidos}

# 8 cultinhos. Semanas seg-dom; hoje = qua 16/09/2026 (semana 14-20/09).
# Ritmo: 8 baldes -> aceso, apagado, aceso x6  => sequencia de 6 semanas.
cultos = [
    culto("c8", "2026-09-15T21:00:00.000", "Lucas",  [leitura(SALMOS, 23, 1, 6)],     [p_vovo, p_casa]),      # esta semana
    culto("c7", "2026-09-09T21:00:00.000", "Clara",  [leitura(JOAO, 1, 1, 14)],       [p_pac]),               # -1
    culto("c6", "2026-09-02T21:00:00.000", "Antônio",[leitura(PROVERBIOS, 3, 5, 6)],  []),                    # -2
    culto("c5", "2026-08-26T21:00:00.000", "Lucas",  [leitura(FILIPENSES, 4, 6, 7)],  [p_emprego]),           # -3
    culto("c4", "2026-08-19T21:00:00.000", "Clara",  [leitura(ROMANOS, 8, 28, 39)],   [p_irma]),              # -4
    culto("c3", "2026-08-12T21:00:00.000", "Lucas",  [leitura(ISAIAS, 41, 10)],       [r_consulta]),          # -5
    # semana -6 vazia (o quadradinho apagado)
    culto("c2", "2026-07-29T21:00:00.000", "Antônio",[leitura(MATEUS, 6, 9, 13)],     [r_vizinhos]),          # -7
    culto("c1", "2026-07-22T21:00:00.000", "Lucas",  [leitura(GENESIS, 1, 1, 5)],     [r_prova]),             # fora da janela
]

print(json.dumps(cultos, ensure_ascii=False, separators=(',', ':')))
print("@@@SPLIT@@@")
print(json.dumps(oracoes, ensure_ascii=False, separators=(',', ':')))
