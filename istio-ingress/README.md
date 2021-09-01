<h1> Istigress controller</h1>
<i> This flow is in the continuation of previous labs.</i>
<p>Steps:</p>
<ul>
    <li>kubectl create namespace dev</li>
    <li>docker build -t hello-kube:v1 ./apps/hello-kube/</li>
    <li>istioctl manifest apply --set profile=demo --namespace dev</li>
    <li>kubectl label namespace dev istio-injection=enabled</li>
    <li>kubectl apply -f ${ISTIO_HOME}/samples/addons/kiali.yaml</li>
    <li>kubectl apply --filename manifest-development.yaml</li>
    <li>Determining the ingress IP and ports
        export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
    </li>
    <li>export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')</li>
    <li>echo "$INGRESS_PORT"</li>
    <li>echo "$SECURE_INGRESS_PORT"</li>
    <li>export INGRESS_HOST=$(minikube ip)</li>
    <li>echo "$INGRESS_HOST"</li>
    <li>Open following in a new terminal window</li>
        minikube tunnel
    </li>
    <li>kubectl get services --namespace dev</li>
    <li>EXTERNAL-IP - should be populated to 127.0.0.1</li>
    <li>gateway URL
        export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
    </li>
    <li>echo "$GATEWAY_URL"</li>
    <li>Setup ingress GATEWAY (namespace dev)</li>
        kubectl apply --filename manifest-istio-ingress-gateway.yaml</li>
    </li>
    <li>kubectl get getway --namespace dev</li>
    <li>Route Traffic to the Service with VirtualService</li>
        kubectl apply --filename manifest-istio-virtualservice.yaml</li>
    </li>
    <li>
        <b>To be noted:</b>
        The Ingress Gateway only tells what traffic can go inside, but VirtualService can tell where the traffic should go.
        namespace: dev
        gateways: [name-of-the-gateway-created-in-previous-step]
    kubectl get virtualservice --namespace dev [alternative kubectl get vs -n dev]
    </li>
    <li><i>Run:</i>
        curl http://127.0.0.1
        Hello Kubernetes World!
    </li>
</ul>
<br />
<h1>Canary deployment using Istio</h1>
<ul>
    <li>docker build -t hello-kube:v2 ./apps/hello-kube/</li>
    <li>kubectl apply --filename ./istio-ingress/manifest-new-service-deployment.yaml</li>
    <li>kubectl get deployments,services --namespace dev</li>
    <li>kubectl apply --filename ./istio-ingress/manifest-istio-virtualservice-50-50.yaml</li>
</ul>