# Integração da API de Cadastro

## Configuração

### 1. Dependências Adicionadas
- `http: ^1.1.0` - Para fazer requisições HTTP

### 2. Estrutura dos Arquivos
```
lib/
├── config/
│   └── api_config.dart          # Configurações da API
├── services/
│   └── api_service.dart         # Serviço para requisições HTTP
└── screens/
    └── register_screen.dart     # Tela de cadastro atualizada
```

### 3. Configuração da API
No arquivo `lib/config/api_config.dart`, você pode configurar:
- URL base da API Django
- Endpoints
- Timeout das requisições
- Headers padrão

## Dados Enviados para a API

A tela de cadastro envia os seguintes dados para o endpoint POST `/api/users/`:

```json
{
  "first_name": "João",
  "last_name": "Silva",
  "email": "joao@email.com",
  "password": "senha123",
  "username": "joao",
  "is_active": true,
  "is_staff": false,
  "is_superuser": false,
  "date_joined": "2024-07-11T17:44:06.000Z",
  "last_login": null,
  "dtnascimento": "1990-01-01" // Opcional, se implementado
}
```

## Funcionalidades Implementadas

### 1. Validação de Formulário
- Nome completo (mínimo 2 caracteres)
- Email válido
- Senha (mínimo 6 caracteres)
- Confirmação de senha
- Data de nascimento (opcional, com DatePicker)

### 2. Processamento de Dados
- Divisão automática do nome completo em primeiro e último nome
- Geração automática do username baseado no email
- Formatação de datas no padrão ISO

### 3. Tratamento de Erros
- Erros de conexão
- Erros de validação da API
- Mensagens de erro amigáveis ao usuário

### 4. Interface do Usuário
- Indicador de carregamento durante o envio
- Mensagens de sucesso e erro
- Navegação automática após cadastro bem-sucedido
- DatePicker para seleção de data de nascimento
- Campos com validação visual e mensagens de erro

## Como Usar

### 1. Configurar a URL da API
No arquivo `lib/config/api_config.dart`, altere a URL base:
```dart
static const String baseUrl = 'http://SEU_SERVIDOR:8000';
```

### 2. Executar o Aplicativo
```bash
flutter pub get
flutter run
```

### 3. Testar o Cadastro
1. Abra o aplicativo
2. Vá para a tela de cadastro
3. Preencha os dados
4. Clique em "Criar Conta"
5. Verifique se o usuário foi criado no Django Admin

## Estrutura da API Django

### Endpoint: POST /api/users/
- **URL**: `http://localhost:8000/api/users/`
- **Método**: POST
- **Content-Type**: application/json

### Campos Obrigatórios:
- `first_name` (string)
- `last_name` (string)
- `email` (string, email válido)
- `password` (string)
- `username` (string, único)

### Campos Opcionais:
- `dtnascimento` (date, formato YYYY-MM-DD)
- `is_active` (boolean, padrão: true)
- `is_staff` (boolean, padrão: false)
- `is_superuser` (boolean, padrão: false)

### Respostas:
- **201 Created**: Usuário criado com sucesso
- **400 Bad Request**: Dados inválidos
- **500 Internal Server Error**: Erro do servidor

## Troubleshooting

### Erro de Conexão
- Verifique se a API Django está rodando
- Verifique se a URL está correta
- Teste a conectividade de rede

### Erro 400 Bad Request
- Verifique se todos os campos obrigatórios estão sendo enviados
- Verifique se o formato dos dados está correto
- Verifique se o email/username já existem

### Erro 500 Internal Server Error
- Verifique os logs do Django
- Verifique se a stored procedure `setuser` está funcionando
- Verifique a configuração do banco de dados

## Próximos Passos

1. Implementar autenticação JWT
2. Adicionar validação de força da senha
3. Implementar recuperação de senha
4. Adicionar campo de data de nascimento na interface
5. Implementar testes unitários
