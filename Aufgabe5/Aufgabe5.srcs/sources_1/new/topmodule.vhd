library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library pshdl;
use pshdl.Casts.ALL;
use pshdl.ShiftOps.ALL;
use pshdl.types.all;
entity de_tuhh_ict_AudioCodecSCLBased is
    port (
        rst : in std_logic;
        sclk : in std_logic;
        T1 : inout std_logic;
        T2 : inout std_logic;
        SDA : inout std_logic;
        SCL : inout std_logic;
        LED : out std_logic_vector(3 downto 0);
        lrck : in std_logic;
        sdout : in std_logic;
        sdin : out std_logic
    );
    type States is (waitLREdge, startSampling, sampleCount);
end;
architecture pshdlGenerated of de_tuhh_ict_AudioCodecSCLBased is
    signal lrck_prev : std_logic;
    signal sample_out : signed(23 downto 0);
    signal sample_in : signed(23 downto 0);
    signal shift_sample_out : std_logic_vector(23 downto 0);
    signal shift_sample_in : std_logic_vector(23 downto 0);
    signal state : States;
    signal nextSample : std_logic;
    signal doShift : std_logic;
    signal counter : unsigned(4 downto 0);
    component fir_compiler_v6_3_0
        port (
            aclk : in std_logic;
            s_axis_data_tvalid : in std_logic;
            s_axis_data_tdata : in std_logic_vector(23 downto 0);
            s_axis_data_tready : out std_logic;
            m_axis_data_tvalid : out std_logic;
            m_axis_data_tdata : out std_logic_vector(23 downto 0)
        );
    end component;
    signal fir_aclk : std_logic;
    signal fir_s_axis_data_tvalid : std_logic;
    signal fir_s_axis_data_tdata : std_logic_vector(23 downto 0);
    signal fir_s_axis_data_tready : std_logic;
    signal fir_m_axis_data_tvalid : std_logic;
    signal fir_m_axis_data_tdata : std_logic_vector(23 downto 0);
begin
    fir : fir_compiler_v6_3_0
        port map (
            aclk => fir_aclk,
            s_axis_data_tvalid => fir_s_axis_data_tvalid,
            s_axis_data_tdata => fir_s_axis_data_tdata,
            s_axis_data_tready => fir_s_axis_data_tready,
            m_axis_data_tvalid => fir_m_axis_data_tvalid,
            m_axis_data_tdata => fir_m_axis_data_tdata
        );
    process(T1, T2, counter, lrck, lrck_prev, nextSample, sample_in, sclk, shift_sample_out, state)
    begin
        T1 <= 'Z';
        T2 <= 'Z';
        SDA <= 'Z';
        SCL <= 'Z';
        LED <= (others => '0');
        sdin <= shift_sample_out(23);
        nextSample <= '0';
        doShift <= '0';
        LED(0) <= T2;
        LED(1) <= T1;
        case state is
            when waitLREdge =>

            when startSampling =>
                doShift <= '1';

            when sampleCount =>
                doShift <= '1';
                if (counter = TO_UNSIGNED(24, 5)) then
                    doShift <= '0';
                    nextSample <= '1';
                end if;

            when others =>

        end case;
        fir_aclk <= sclk;
        fir_s_axis_data_tvalid <= nextSample;
        fir_s_axis_data_tdata <= std_logic_vector(sample_in);
    end process;
    process(sclk)
    begin
        if sclk'EVENT and sclk = '1' then
            if rst = '1' then
                lrck_prev <= '0';
                sample_out <= (others => '0');
                sample_in <= (others => '0');
                shift_sample_out <= (others => '0');
                shift_sample_in <= (others => '0');
                state <= waitLREdge;
                counter <= (others => '0');
            else
                lrck_prev <= lrck;
                counter <= (counter + 1);
                shift_sample_in <= shift_sample_in(22 downto 0) & sdout;
                if (doShift /= '0') then
                    shift_sample_out <= sllBitvector(shift_sample_out, 1);
                end if;
                case state is
                    when waitLREdge =>
                        if (lrck_prev /= lrck) then
                            state <= startSampling;
                        end if;

                    when startSampling =>
                        counter <= (others => '0');
                        state <= sampleCount;

                    when sampleCount =>
                        if (counter = TO_UNSIGNED(24, 5)) then
                            state <= waitLREdge;
                        end if;

                    when others =>

                end case;
                if (nextSample /= '0') then
                    shift_sample_out <= std_logic_vector(sample_out);
                    sample_in <= bitvectorToInt(shift_sample_in);
                end if;
                if (T1 /= '0') then
                    sample_out <= bitvectorToInt(fir_m_axis_data_tdata);
                else
                    sample_out <= sample_in;
                end if;
            end if;
        end if;
    end process;
end;
