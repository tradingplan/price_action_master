# Certificate Schema Documentation

O `certificate.schema.json` especifica a estrutura do certificado de conclusão emitido localmente pela plataforma ao término de um curso.

---

## Estrutura do Schema

```json
{
  "id": "string (ex: 'cert_smc_1298a')",
  "courseId": "string",
  "studentName": "string",
  "issuedAt": "string (data ISO 8601)",
  "verificationHash": "string (código SHA-256 local para autenticidade)",
  "metadata": {
    "xpEarned": "integer",
    "correctAnswers": "integer"
  }
}
```

---

## Algoritmo de Verificação Local
Para garantir que o arquivo de persistência não foi corrompido, a plataforma gera o `verificationHash` concatenando os dados do estudante, ID do curso e data de emissão usando uma chave secreta local da plataforma.
Isso valida a integridade do certificado offline de custo zero.
