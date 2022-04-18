function Gn=Gnorm(T,k,ts,kp_d,data)
    
    G= tf([k], [T 1 0]);
    G_d= c2d(G,ts,'zoh');
    Go=kp_d*G_d;
    Gcl= feedback(Go,1);
    Gtk= step(Gcl,ts*(length(data)-1));
 
    Gn=norm(Gtk-data);

end
