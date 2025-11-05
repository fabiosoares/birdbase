{% macro tratarCamposTp() %}

CREATE OR REPLACE FUNCTION {{target.schema}}.tratarCamposTp(valor STRING, separador STRING)
RETURNS string
LANGUAGE js AS """

function normalizarString(str, sep) {
    const accentMap = {
        'ÀÁÂÃÄÅ': 'A', 'àáâãäå': 'a',
        'ÈÉÊË': 'E', 'èéêë': 'e',
        'ÌÍÎÏ': 'I', 'ìíîï': 'i',
        'ÒÓÔÕÖ': 'O', 'òóôõö': 'o',
        'ÙÚÛÜ': 'U', 'ùúûü': 'u',
        'Ç': 'C', 'ç': 'c',
        'Ñ': 'N', 'ñ': 'n'
    };

    for (const [accents, replacement] of Object.entries(accentMap)) {
        const regex = new RegExp(`[${accents}]`, 'g');
        str = str.replace(regex, replacement);
    }

    // Substitui underscores, espaços, vírgulas, parênteses e barras pelo separador
    str = str.trim().replace(/[_\\s,()\\/]+/g, sep);

    // Remove duplicatas do separador
    str = str.replace(new RegExp(`${sep}+`, 'g'), sep).toUpperCase();

    // Verifica se a string termina com o separador e ajusta se necessário
    if (str.endsWith(sep) && valor.endsWith(')')) {
        str = str.slice(0, -sep.length); // Remove o separador no final
    }

    return str;
}

if (!valor || valor.trim() === "") return null;
if (!separador || separador.trim() === "") separador = '-';

return normalizarString(valor, separador);
"""

{% endmacro %}

-- /Users/fabiosoares/projects/alchemy/omni_dw/models/ammo_varejo_dm_estoques/ammo_varejo_ft_estoques_atuais.yml
-- Campos com _ (tp_loja: "CD_LOJA:) e sem o padrão (tp_curva_abc: "Sem curva definida")